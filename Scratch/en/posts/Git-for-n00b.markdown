-----
isHidden:       false
menupriority:   1
kind:           article
published: 2009-11-12
title: Git for n00b
authorName: Yann Esposito
authorUri: yannesposito.com
subtitle: introduction
tags: git
-----

<div class="intro">

 A detailed tutorial of <a href="http://git-scm.org">Git</a> for people knowing very few about versions systems.
You'll understand utility of such program and how we use modern version control system.
I try to stay as pragmatic as possible.

</div>



# Begin with conclusion

Here is the list of sufficient and necessary command to use [Git][git].
There is very few.
It is normal not to understand immediately but it is to gives you an idea.
Even if this article is long, 95% of [Git][git] usage is in these 7 commands:

Get a project from the web:

	git clone ssh://server/path/to/project

Everyday [Git][git] usage:

~~~
# get modifications from other
git pull
# read what was done
git log

# Make local changes to files
hack, hack, hack...
# list the modified files
git status
# show what I've done
git diff

# tell git to version a new file
git add new/file

# commit its own modifications
# to its local branch
git commit -a -m "Fix bug #321"

# send local modifications to other
git push
~~~

This article is written for people knowing very few about versionning systems.
It is also written for those who had didn't followed progress since CVS or subversion (SVN).
This is why, in a first time I'll explain quickly which are the goal of such systems.
Secondly, I'll explain how to install and configure [Git][git].
Then, I give the command for each feature a <abbr title="Decentralized Concurent Versions System">DCVS</abbr> must have.

# [Git][git] for what?

<div class="intro">

If you just want to use [Git][git] **immediately**, just read dark part.
You read this part later to understand correctly foundations of version systems and not doing strange things.

</div>

[Git][git] is a <abbr title="Decentralized Concurent Versions System">DCVS</abbr>, which means a Decentralized Concurrent Versions System.
Let's analyze each part of this long term:

### Versions System

Firstly, versions system manage files.
When somebody work with files without a versions system, the following happens frequently:

When you modify a somehow critical file you don't want to loose.
You copy naturally this file with another name.
For example:

	$ cp fichier_important.c fichier_important.c.bak

In consequence of what, the new file, play the role of *backup*.
If you break everything, you can always return in the last state by overwriting your modifications.
Of course, this method is not very professional and is a bit limited.
If you make many modifications, you'll end with many files with strange names like:

	fichier_important.c.bak
	fichier_important.c.old
	fichier_important.c.Bakcup
	fichier_important.c.BAK.2009-11-14
	fichier_important.c.2009.11.14
	fichier_important.c.12112009
	old.fichier_important.c

If you want to make it works correctly, you'll have to use naming convention.
Files take many place even if you modify most of time only some lines.

*Fortunately, versions system are here to help.*

You only have to signal you want a new version of a file and the versions system will do the job for you.
It will record the backup where it could be easily recovered.
Generally, systems version do it better than you, making the backup only of the modified lines and not the total file.

Once upon a time versions were managed for each file separately.
I think about CVS.
Then it naturally appears projects are a coherent set of files.
Recover each file separately was a tedious work.
This is why versions number passed from files to the entire project.

It is therefore possible to say, "I want to get back three days earlier".

<div class="black">

*What gives versions system?* (I didn't mention everything at all)

- automatic backups: *back in time*,
- gives the ability to see differences between each version,
- put a *tag* on some version to be able to refer to them easily,
- gives the ability to see an historic of all modifications.
Generally the user must add a comment for each new version.

</div>

### concurrent:

Version Systems are already useful to manage its own projects.
They help to organize and resolve partially backup problems.
I say partially because you have to backup your repository on a decent file system.
But versions system are really interesting is on projects done by many people.

Let's begin by an example, a two person project ; Alex and Beatrice.
On a file containing a *Lovecraft*'s gods list:

	Cthulhu
	Shubniggurath
	Yogsototh

Say Alex is home and modify the file:

<pre>
Cthulhu
Shubniggurath
<span class="yellow"><strong>Soggoth</strong></span>
Yogsototh
</pre>

after that he send the file on the project server.
Then on the server there is the Alex file:

A bit later, Beatrice who had not get the Alex file on the server make the modification:

<pre>
Cthulhu
<span class="blue"><strong>Dagon</strong></span>
Shubniggurath
Yogsototh
</pre>

Beatrice send her file on the server

Alex modification is *lost*.
One more time, versions system are here to help.

A version system would had *merge* the two files at the time Beatrice send the file on the server.
And like by magic, on the server the file would be:

<pre>
Cthulhu
<span class="blue"><strong>Dagon</strong></span>
Shubniggurath
<span class="yellow"><strong>Soggoth</strong></span>
Yogsototh
</pre>

In real life, at the moment Beatrice want to send her modifications, the versions system alert her a modification had occurred on the server.
Then she uses a command which pull the modification from the server to her local computer.
And this command update her file.
After that, Beatrice send again the new file on the server.

<div class="black">

**In what Concurrent Versions System help?**

- get without any problem others modifications,
- send without any problem its own modifications to others,
- manage conflicts.
I didn't speak about it, but sometimes a conflict can occur (when two different people modify the same line on a file for example).
SVC help to resolve such problem.
More on that later,
- help to know who done what and when.

</div>

### decentralized

This word became popular only recently about CVS.
And it mainly means two things:

First, until really recently (SVN), you'll have to be connected to the distant server to get informations about a project.
Like get the history.
New decentralized systems work with a local *REPOSITORY* (directory containing backups and many informations linked to the versions system functionalities).
Hence, one can view the history of a project without the need of being connected.

All instances of a project can live *independently*.

To be more precise, DCVS are base on the *branch* notion.

Practically, it has great importance.
It means, everybody work separately, and the system help to glue all their work.

It is even more than just that.
It help to code independently each feature and bug fixes.
Under other system it was far more difficult.

Typical example:

> I develop my project.
I'm ameliorating something.
An urgent bug is reported.
>
> With a DCVS I can easily, get back to the version with the bug.
Fix it.
Send the fix.
Get back to my feature work.
And even, use the fix for the new version with my new feature.
>
> In a not decentralized version system, doing such a thing is possible but not natural.
Decentralization means it become natural to use a branch for each separable work.

<div class="black">

**Advantages given by DCVS:**

- Ability to work offline,
- Ability to create many *atomic* patches,
- Help the maintenance of many different versions of the same application.

</div>

## To resume

Let's resume what we can easily do with DCVS:

**Versions Systems**

- back in time,
- list differences between versions,
- name some versions to refer to them easily
- show history of modifications

**Concurrent**

- get others modifications,
- send its modifications to others,
- know who done what and when,
- conflicts management.

**Decentralized**

- Easily manipulate branches

Now let's see how to obtain all these things easily with [Git][git].

# Here we go!

Here is one from many way to use [Git][git].
This method is sufficient to work on a project.
Not there is many other *workflows*.

## Basic usage

Work with [Git][git] immediately:

+ Get modification done by others `git pull`,
+ See details of these modifications `git log`,
+ Many times:
  + *Make an atomic modification*
  + Verify details of this modification: `git status` and `git diff`,
  + Add some file to be versionned if necessary:<br/>`git add [file]`,
  + Save you modifications <br/>`git commit -a -m "message"`,
  + Send your modifications to others: `git push` (redo a `git pull` if push return an error).

With these few commands you can use [Git][git].
Even if it is sufficient, you need to know one more thing before really begin ; How to manage *conflicts*.

### Conflicts management

Conflicts can arise when you change the same line of code on the same file from another branch you're merging.
It can seems a bit intimidating, but with [Git][git] this kind of thing is really simple to handle.

#### example

You start from the following file

	Zoot

and you modify one line

<pre>
Zoot <span class="yellow"><strong>the pure</strong></span>
</pre>

except during this time, another user had also modified the same line and had done a `push`.

<pre>
Zoot<span class="blue"><strong>, just Zoot</strong></span>
</pre>

Now when you do a:

	$ git pull
	remote: Counting objects: 5, done.
	remote: Total 3 (delta 0), reused 0 (delta 0)
	Unpacking objects: 100% (3/3), done.
	From /home/yogsototh/tmp/conflictTest
	   d3ea395..2dc7ffb  master     -> origin/master
	Auto-merging foo
	CONFLICT (content): Merge conflict in foo
	Automatic merge failed; fix conflicts and then commit the result.

Our file `foo` now contains:

	<<<<<<< HEAD:foo
	Zoot the pure
	=======
	Zoot, just Zoot
	>>>>>>> 2dc7ffb0f186a407a1814d1a62684342cd54e7d6:foo

#### Conflict resolution

To resolve the conflict you only have to edit the file for example, writing:

<pre>
Zoot <span class="green"><strong>the not so pure</strong></span>
</pre>

and to commit

	git commit -a -m "conflict resolved"

Now you're ready to use [Git][git].
[Git][git] provide many other functionnalities.
Now we'll see some [Git][git] usages older CVS couldn't handle.

[git]: http://git-scm.org "Git"


# Why Git is cool?

Because with [Git][git] you can work on many part of some project totally independently.
This is the true efficiency of decentralisation.

Each branch use the same directory.
Then you can easily change your branch.
You can also change branch when some files are modified.
You can then dispatch your work on many different branches and merge them on one master branch at will.

Using the `git rebase` you can decide which modifications should be forget or merged into only one modification.

What does it mean for real usage? You can focus on coding.
For example, you can code, a fix for bug b01 and for bug b02 and code a feature f03.
Once finished you can create a branch by bug and by feature.
And finally you can merge these modifications on a main branch.

All was done to code and decide how to organize your versions after.
In other VCS it is not as natural as in [Git][git].

With [Git][git] you can depend of many different sources.
Then, there is not necessarily a 'master' repository where everybody puts its modifications.

What changes the most with [Git][git] when you come from SVN, it's the idea of a centralized project on one server.
With [Git][git] many people could work on the same project but not necessarily on the same *repository* as main reference.
One can easily fix a bug and send a patch to many different versions of a project.

[git]: http://git-scm.org "Git"


# Command List

## Command for each functionality

In the first part, we saw the list of resolved problem by [Git][git].
To resume [Git][git] should do:

- get others modifications,
- send modifications to others,
- get back in time,
- list differences between each version,
- name some versions in order to refer easily to them,
- write an historic of modifications,
- know who did what and when,
- manage conflicts,
- easily manage branches.

### get others modifications

	$ git pull

### send modifications to others

	$ git push

or more generally

	$ git pull
	$ git push

### get back in time

#### For all tree

	$ git checkout

	$ git revert

revert three version before (see my `.gitconfig` file).

	$ git uncommit 3

Undo the las merge (if something goes wrong)

	$ git revertbeforemerge

#### For one file

	$ git checkout file
	$ git checkout VersionHash file
	$ git checkout HEAD~3 file

### list differences between each version

list files being modified

	$ git status

differences between last version files and local files

	$ git diff

differences between some version and local files

	$ git diff VersionHash fichier

### name some version to refer to them in the future

	$ git tag 'toto'

### show historic of modifications

	$ git log
	$ git lg
	$ git logfull

### know who did what and when

	$ git blame fichier

### handle conflicts

	$ git conflict

### manage branches

To create a branch:

	$ git branch branch_name

To change the current branch:

	$ git checkout branch_name

[git]: http://git-scm.org "Git"
