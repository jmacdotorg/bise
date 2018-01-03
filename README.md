# Bise

Bise generates a tidy little summary of your blog's current human readership, based on the most recent couple of weeks' server logs. Its output looks like this:

```
December 14 - December 28
Source                 Uniques Regulars
---------------------------------------
All visitors              2489      260
RSS feed                   305      147
JSON feed                   10        1
Front page                1664       47
From Twitter                31        6
```

In this table, "Uniques" means the number of unique and probably-human visitors according to that row's criteria, and "Regulars" means the number of probably-human _regular readers_, those who have visited your blog more than once over the two-week span Bise considers.

From the above example output, then, we could consider our regular readership as around 200 people, adding the number of apparent RSS subscribers (147) and repeat front-page visitors (47).

Or we could more generously call it 260 people, looking simply at the number of visitors who've dropped by any part of the site more than once. This latter number would include, for example, someone who found a particular article via a search engine one day, and then returned to the same article a few days later for reference, but didn't explore the rest of the blog. Bise leaves the question of whether to consider such visitors "regular readers" up to the user's own judgment.

Bise wants to run regularly, perhaps in a weekly crontask that sends you its output in email. By limiting its considered data to only the last couple of weeks, Bise gives you a rolling summary of your blog's active readership, rather than a strictly cumulative view.

For further defense of this program existing in world full of much more rich and stable Apache log analyzers, see "Apologia", below.

## Usage

Once you've got Bise set up (see "Setup", below), run it on the command line, providing a list of log files as arguments:

```
 ./bise /var/log/apache/blog-access.log*
``` 
 
Bise assumes two things about the referenced log files:

1. They are in [common log format](https://en.wikipedia.org/wiki/Common_Log_Format).

1. Their names are sortable by date according to Apache's default log-file naming scheme: the newest file is _blah-blah_.log, the next-newest _blah-blah_.log.1, then _blah-blah_.log.2, and so on.

Some of these logs (or, indeed, most) can also be gzipped (and thus have names ending in .gz, after the ordering-digit) and Bise will do the right thing.

## Output details

### Columns

* **Uniques** lists the number of unique remote IP addresses meeting this row's criteria.

* **Regulars** displays the number of unique remote IP addresses that have met the row's criteria more than once, with more than one day elapsing between their earliest and their latest visit.

### Rows

Rows are entirely user-defined. Set up a list of substring-match or pattern-match tests for Bise to run against each salient line of the web server's log files, and Bise will display the results of each test in a single, labeled row of its output table.

The example output at the top of this document displays five such reports, and these happen to correspond to the example configuration file found in `conf/conf-example.yaml`.

See "Configuration", below, for more information.

## Project status

Super-duper alpha. As of early 2018 I've only just started using this tool myself, and I'm still working on determining what shape it wants to be. Every facet of it is highly susceptive to abrupt change while this happens.

## Setup

### Installation

To install Bise's dependencies, run the following command from the top level of your Bise repository (the directory that contains this here README file):

    curl -fsSL https://cpanmin.us | perl - --installdeps .
    
This should crunch though the installation of a bunch of Perl modules that Bise needs.

### Configuration

Copy `conf/conf-example.yaml` to `conf/conf.yaml` and update as you'd like. See the example config doc itself for config documentation.

I dare say that this example config file is ready to generate meaningful reports as-is, once you customize the paths a bit. (And you'll probably want to remove the JSON Feed test, because you probably don't use [JSON Feed](https://jsonfeed.org). But maybe you do, in which case, hey.)

## How Bise gets its numbers

For every sufficiently recent log-line fed to it, Bise determines which of these possible entities it comes from: 

* A feed aggregator, reporting the number of human readers it represents.

* Another kind of automated process, whose visit we shall disregard.

* An apparent human, visiting individually.

If the request came from a human or reader-reporting aggregator, Bise then runs the request past every user-defined test, each of which corresponds to a single row in the final output table. Every positive result from a unique IP (for human visitors) or a unique user-agent (for aggregators) gets added to the "Uniques" total for that test.

Furthermore, Bise stores the earliest and latest timestamps for each positive test result per visitor. It then uses this data to count the subset of "regular" visitors, versus those who only swung by the blog once.

## Apologia

Bise differentiates itself from other server-log analyzers by attempting to summarize a website's _readership_, as opposed to its raw visitor traffic.

I have analyzed [my blog](http://fogknife.com)'s visitor logs using [AWStats](http://www.awstats.org) for many years. It does a fine job, especially for getting a big-picture view of a blog's overall traffic!

But, as a numbers-obsessed blog author, I found AWStats too general a tool to give me certain very precise statistics I sought. These included not just raw hit-counts on my RSS feed, but a notion of how many unique humans this represented -- including those subscribed indirectly, through aggregation services. 

Furthermore, I know that much of my readership doesn't use RSS, instead manually visiting the front page from time to time. Others swing by via the tweets I post for every new article. I wanted to track these readers too, and to further differentiate between one-time visitors and those who keep coming back to check for new content. This latter number especially I found intriguing and elusive, but none of these desires could be met by AWStats or any other general-purpose server-log analyzer.

Were I a wizard with Google Analytics, I suppose it likely that I could build something to meet my needs there, albeit using some tortured pile of script-driven redirections in order to somehow allow it to work with the blog's RSS feed as well as its HTML-based content. But that sounds like a very horrible idea, so I made Bise instead.

## "Bise"?

[According to Wikipedia](https://en.wikipedia.org/wiki/Bise):

> In Switzerland, the Bise is a cold, dry wind from northeast which blows through the Swiss Midland. It is caused by canalisation of the air-current along the northern edge of the Alps, during high-pressure conditions in northern or eastern Europe respectively. Towards western Midland, the Bise is pressed between the Jura mountains and Pre-Alps whereby it strengthens and mostly climaxes on the western shore of Lake Geneva. In summer, Bise wind causes rather dry and sunny weather whereas in winter, it frequently forms low stratus clouds over the Midland by strengthening the inversion layer. Many foreign travellers to this Swiss city have commented upon it.

None of which has much to do with analyzing server logs, granted. Starting in 2017, I began naming my new projects after regional winds. As of early 2018 this effort has advanced only a little ways down [the alphabetical list](https://en.wikipedia.org/wiki/List_of_local_winds). So, "Bise" it is.

I pronounce it "BEE-zuh".

## Credits

Bise is by Jason McIntosh (<jmac@jmac.org>). I welcome any questions or comments via email.
