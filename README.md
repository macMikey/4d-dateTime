# 4d-mikeyDateTime
A class(and examples) for managing dates and times in 4D.



## Description

* Designed to be used as a component/submodule

* See the class documentation for the API.



## Installation

1. I prefer submoduing this repo so updates to the code base trigger notifications in the repos that use it. I usually put them into a folder like **Submodules** in the parent project, or **Resources/Submodules**, etc. I do that because 4D does not like to have submodules directly in the **Components** folder, but it will be ok with having aliases/shortcuts in that folder.

2. Copy/Alias/Shortcut *4d-dateTime.4dProject* to the parent project's **Components** folder.

   * The **Components** folder and the **Project** folder of the source database should be at the same level.

   * If this has worked, when you go into your parent project, in the 4D Explorer, you should see *4d-text-chunking* and its methods and classes in the **Component Methods** section.




## Notes

* The classes are available via the **cs.mdt** (i.e. mikeyDateTime) namespace.  Example: `$dtO:=cs.mdt.new()`
