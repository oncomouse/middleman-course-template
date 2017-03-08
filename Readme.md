# middleman-course-template

This template allows the creation of simple, responsive course websites for college-level courses. It uses YAML to create the schedule of instruction and [Middleman's vast array of supported languages](https://middlemanapp.com/basics/templating_language/) for page content. It uses bits of [Bootstrap](http://getbootstrap.com/) for responsive navigation and some layout. It also is heavily customizable to create unique, course-specific layouts.

This template also attempts to bake in support for IE8 using [html5shiv](https://github.com/aFarkas/html5shiv), [respond.js](https://github.com/scottjehl/Respond), and [css3-mediaqueries.js](https://code.google.com/p/css3-mediaqueries-js/).

You [can view a sample course at http://andrew.pilsch.com/courses/sample-course/](http://andrew.pilsch.com/courses/sample-course/)

## Setup

### Dependencies

* [Ruby](https://www.ruby-lang.org/)
* [Bundler](http://bundler.io/)

### Instructions

To install, run `bundle install` from a Terminal.

To start the development server, run `middleman` and visit [http://localhost:4567](http://localhost:4567).

### Tips for Installing Ruby, Bower, & Bundler

Starting from scratch with Middleman, you will need to install [Ruby](https://www.ruby-lang.org) (I *strongly* [recommend using RVM for this](http://rvm.io).).

Once you have Ruby working, you can run `gem install bundler` to install the two package management utilities used by this package.

## Editing The Course

Changing the `course.yml` file controls the default displays of the course. The <abbv>HAML</abbv> files that begin with course in `source/partial` (`_course-description.haml` and `_course-title.haml`) can be edited for more control.

The course schedule of assignments, readings, etc. is built by editing the `schedule.yml`.

As a rule, you should not need to edit `sourc/partials/links.haml`, `source/course.yml.erb`, and `schedule.html.erb`.

### Changing Syllabus Appearance

To change the color scheme of the syllabus (something you should do for each class!), you will need to edit `source/stylesheets/_variables.scss`. This file contains a series of overrides and custom variables, but the most important variable in this file is `$course_color`. Changing this variable overrides the default background color for your course and changes links, borders, and the overall appearance of the syllabus. 

I've included the SASS-Colors library, which contains a host of named variables for colors to use in SASS. You can see a full list of the colors (along with samples) [here](https://dl.dropboxusercontent.com/u/28696035/samples.html).

For some of the colors, you may need to change the percentages passed to `lighten()` and `darken()`, so experiment to get the color you want.

### Customizing Bootstrap

This template uses a very minimal version of Bootstrap, only the core functions, navbar, and the collapsing navbar javascript. If you would like to use more Bootstrap functionality in your syllabuses, edit `source/javascripts/bootstrap.js` to load more JS features and edit `source/stylesheets/_bootstrap.scss` to include more CSS features.

### Changing Build Behavior

In `config.rb`, there are two variables to set: `config[:build_http_prefix]`, which is the HTTP root for your course, when it deploys. For instance, a course called `eng101spr2015` that existed online at `http://andrew.pilsch.com/courses/eng101spr2015`, would have `config[:build_http_prefix]` set to `/courses/eng101spr2015` (the variable `@course_tag` is set up to do this by default). 

Additionally, the javascript files `app.js` and `css3-mediaqueries.js` can be shared between multiple course sites. Set `config[:shared_javascript_prefix]` to the URL of the directory where these shared files are located (for instance, `http://andrew.pilsch.com/courses/shared-javascripts/`). Leave it set as `''` if you don't need this behavior.

### Changing Deployment Behavior

This template uses [middleman-deploy](https://github.com/middleman-contrib/middleman-deploy) to automate deployment.

## Creating New Pages

### Automated Page Creation

This template includes a [Rakefile](https://github.com/ruby/rake) to automate page creation. To create pages in this manner, run `rake create_page[file_name.html.md]` in the terminal (where `file_name.html.md` is the name of the file in the `source/` directory you want to create). The rake task will create the page and set up the basic YAML front matter (see below). You do not have to use the rake task to create pages, it is merely provided as a convenience.

### Editing YAML Frontmatter

Files created in the `source/` directory that compile to html (eg `policies.html.haml` or `assignments.html.md`) need a [YAML](http://yaml.org) [metadata block](https://middlemanapp.com/basics/frontmatter/) (set off above and below with `---` and at the top of the document, as [covered in Middleman's documentation](https://middlemanapp.com/basics/frontmatter/)) with the `page_link_name` property set to the text displayed in the page's navigation link.

``` yaml
---
page_link_name: Foobar
---
```

You can also create sidebar widgets using the following YAML fragment as a template:

``` yaml
---
page_sidebar_widgets:
- |
  ### Markdown Formated Widget Content
  
  Hello, this is a widget
- |
  ### This is a 2nd Widget
  
  Boom
---
```

Note that the Markdown formatted content of these widgets must be indented by two spaces (`  `) for Middleman to compile and load the page.

## The Course Schedule (`data/schedule.yml`)

To schedule course activities (readings, homework assignments, etc), edit `data/schedule.yml`. This [YAML](http://yaml.org) file controls the schedule of courses.

The first two items in the schedule are start and end dates for the class (`start: ` and `end: ` in the file). They should be set in the `YYYY-MM-DD` format. `start:` can refer to the first meeting of your class *or* the day that classes start at your institution. Similarly, `end:` can refer to either the final meeting of your class or the day that classes end at your institution.

Next comes an array of holidays (`holidays:`). Each holiday needs to begin with two spaces and the `date:` key. You do not have to assign each holiday a name (which can be things like "Winter Break" or "Teaching Absent"), but do so, on a new line below the `date:` command you wish to name, begin with four spaces and add the `name:` key and the name for this holiday.

`meets:` is an array of days of the week on which your class meets. This template uses a natural language processor to translate these into usable `Date` objects in Ruby, so you don't have to worry about capitalization here.

`units`: is an array containing a collection of units (indicated by title and week on which they begin). You can break your syllabus into as many units as you have weeks.

`weeks:` is a hash containing the names of each course week. If you want to assign the first week the title of "Course Introduction", you can type `  1: Course Introduction`. These are totally optional and not having them will not change the behavior of this template.

`classes:` contains an array of days in your course. Each day is indicated by two spaces and `- |` the content of the day starts with four spaces on each line and is written in [Markdown](http://daringfireball.net/projects/markdown/). The course will fill out the weeks and months of your class as it processes this list. If you have too many class meetings, the template will simply stop rendering them when the end of term date (`end:`, discussed above) is reached. If you have too few classes, it will only render those you've provided.

## Course Metadata (`data/course.yml`)

The `data/course.yml` file contains information about the course. These pieces of metadata control the basic display of the course, primarily through files contained in the `source/partials` directory. Edit this file to reflect your course's structure and information. Additionally, if you don't like the way something is displaying, edit the responsible partial to better match what you want.