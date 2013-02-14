--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Control.Monad          (forM) 
import           Control.Applicative    ((<$>))
import           Data.Monoid            (mappend,(<>))
import           Hakyll

import           Data.Map               (Map)
import           Data.List              (sortBy)
import           Data.Ord               (comparing)
import           System.Locale          (defaultTimeLocale)
import qualified Data.Map               as M

import           Abbreviations          (abbreviationFilter)
import           YFilters               (blogImage,frenchPunctuation)
import           Multilang              (multiContext)
import           System.FilePath.Posix  (takeBaseName)


--------------------------------------------------------------------------------
-- Simply copy in the right place
staticBehavior :: Rules ()
staticBehavior = do
  route   idRoute
  compile copyFileCompiler

--------------------------------------------------------------------------------
-- change the extension to html
-- prefilter the markdown
-- apply pandoc (markdown -> html)
-- postfilter the html
-- apply templates posts then default then relitivize url
markdownBehavior :: Rules ()
markdownBehavior = do
  route $ setExtension "html"
  compile $ do
    body <- getResourceBody
    id <- getUnderlying
    itemPath <- getRoute id
    return $ renderPandoc (fmap (preFilters itemPath) body)
    >>= applyFilter postFilters
    >>= loadAndApplyTemplate "templates/post.html"    postCtx
    >>= loadAndApplyTemplate "templates/default.html" postCtx
    >>= relativizeUrls
  where
    applyFilter f str = return $ (fmap $ f) str
    preFilters :: Maybe String -> String -> String
    preFilters itemPath =   abbreviationFilter
                          . blogImage itemName
                          where
                            itemName = maybe "" takeBaseName itemPath
    postFilters :: String -> String
    postFilters = frenchPunctuation

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "Scratch/img/**"   staticBehavior
    match "Scratch/js/**"       staticBehavior
    match "Scratch/css/fonts/*" staticBehavior

    match "Scratch/css/*" $ do
        route   $ setExtension "css"
        compile $ getResourceString >>=
          withItemBody (unixFilter "sass" ["--trace"]) >>=
          return . fmap compressCss

    match "Scratch/en/posts/*" markdownBehavior
    match "Scratch/fr/posts/*" markdownBehavior

    match (fromList ["Scratch/about.rst", "Scratch/contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" yDefaultContext
            >>= relativizeUrls

    create ["Scratch/archive.html"] $ do
        route idRoute
        compile $ do
            let archiveCtx =
                    field "posts" (\_ -> postList createdFirst) <>
                    constField "title" "Archives"              <>
                    yDefaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            let indexCtx = field "posts" $ \_ -> postList ((fmap (take 3)) . createdFirst)

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" postCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
yDefaultContext = metaKeywordContext <>
                  multiContext <>
                  prefixContext <>
                  defaultContext

--------------------------------------------------------------------------------
prefixContext = field "webprefix" $ \_ -> return $ "/Scratch"

--------------------------------------------------------------------------------
metaKeywordContext = field "metaKeywords" $ \item -> do
  metadata <- getMetadata (itemIdentifier item)
  return $ maybe "" renderMeta $ M.lookup "tags" metadata
    where
      renderMeta tags =
        "<meta name=\"keywords\" content=\"" ++ tags ++ "\">\n"

--------------------------------------------------------------------------------
createdFirst :: [Item String] -> Compiler [Item String]
createdFirst items = do
  itemsWithTime <- forM items $ \item -> do
    utc <- getItemUTC defaultTimeLocale $ itemIdentifier item
    return (utc,item)
  return $ map snd $ reverse $ sortBy (comparing fst) itemsWithTime

--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    yDefaultContext

--------------------------------------------------------------------------------
postList :: ([Item String] -> Compiler [Item String]) -> Compiler String
postList sortFilter = do
    posts   <- loadAll "Scratch/en/posts/*" >>= sortFilter
    itemTpl <- loadBody "templates/post-item.html"
    list    <- applyTemplateList itemTpl postCtx posts
    return list
