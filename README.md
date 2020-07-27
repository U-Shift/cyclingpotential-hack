
<!-- README.md is generated from README.Rmd. Please edit that file -->
Cycling Potential Hackathon: Lisbon
===================================

<!-- badges: start -->
<!-- badges: end -->
Welcome to the Cycling Potential Hackathon, Lisbon (CPHL), on reproducible methods for estimating cycling potential, based on a case study of Lisbon, Portugal.
![](https://user-images.githubusercontent.com/1825120/87960376-21e40a00-caac-11ea-8103-5948dfcd3a25.jpg)
This [GitHub repo](https://github.com/U-Shift/cyclingpotential-hack) contains everything needed to get started with modelling cycling potential, including example data and reproducible code.

Interested in getting involved? Here's some [key information](https://en.wikipedia.org/wiki/Five_Ws) that will help decide if this is for you and register to participate if so!

Who?
----

**The hackathon is organised** by Rosa Felix of the [University of Lisbon](http://ushift.tecnico.ulisboa.pt/team-rosa-felix/) and Robin Lovelace of the [University of Leeds](https://environment.leeds.ac.uk/transport/staff/953/dr-robin-lovelace), who were awarded funding from the Portuguese Association of Researchers and Students in the United Kingdom's Bilateral Research Fund ([PARSUK BRF](https://en.parsuk.pt/brf)) to develop a '[PCT Portugal](http://ushift.tecnico.ulisboa.pt/pct-portugal/)' project building on methods used to develop the Propensity to Cycle Tool ([PCT](https://www.pct.bike/)), which is based on open source software.

**Attendees** are expected to have knowledge of transport planning interventions to enable cycling uptake and/or technical skills needed to analyse, interactively visualise and develop scenarios of cycling uptake. Experience with the statistical programming language R will be particularly useful, although anyone with experience of front-end or back-end development with open source software will be very welcome. **Working knowledge of GitHub is highly recommended for collaboration during the hackathon.** [Here is a tutorial example](https://www.youtube.com/watch?v=iv8rSLsi1xo) to get familiarized with GitHub.

What?
-----

A one day participatory code-focussed hackathon. The morning will be dedicated to getting up-to-speed with the input data. The afternoon will be dedicated to the hackathon!

When?
-----

Friday 25<sup>th</sup> September, 2020, 10:00 to 16:00 (UTC±0)

Where?
------

Online, we will send a conference link to participants.

Why?
----

There is a great need for transparent and actionable evidence to support investment in sustainable transport futures, and cycling uptake in particular.

Before signing-up
-----------------

Please take a read of the information below and take a look at (and ideal test) the following resources:

-   exercises in the [PCT Training course](https://itsleeds.github.io/pct/articles/pct_training.html)
-   Geocomputation with R online [book](https://geocompr.robinlovelace.net/), especially Chapter [12](https://geocompr.robinlovelace.net/transport.html) on transport data
-   Papers on the PCT: Lovelace et al. ([2017](https://doi.org/10.5198/jtlu.2016.862)) and Goodman et al. ([2019](https://doi.org/10.1016/j.jth.2019.01.008))
-   Lisbon cycling potential and bike network analysis: Abad and Van der Meer ([2018](https://doi.org/10.3390/info9110287) - paper); Abad and Van der Meer ([2018](https://github.com/GeoTecINIT/OpenData4OpenCities/blob/master/Presentations/AGILE_2018_Presentation_Abad-vdMeer.pdf) - presentation)
-   Test out the PCT at <https://www.pct.bike/>

If you plan to use R to develop solutions, please ensure you can reproduce the results of the code shown here: [reproducible-example.R](https://github.com/U-Shift/cyclingpotential-hack/blob/master/code/reproducible-example.R). If your output looks like [this](https://github.com/U-Shift/cyclingpotential-hack/blob/master/reproducible-example.md) congratualtions :tada:🎉 you have the necessary packages installed.

Agenda (draft)
--------------

-   Introduction to the hackathon: 10:00 - 10:45
-   Talks: methods for modelling cycling networks: 10:45 - 11:15
-   Live, interactive demo of data: 11:15 - 12:00
-   Topic pitches 12:00 - 12:10

Lunch break and finalising teams 12:10 to 13:00

-   Hackathon 13:00 - 15:30
-   Presentation of results 15:30 - 16:00

Input datasets
--------------

Initial datasets, `.geojson`

1.  Desire lines between cities
2.  Cycling routes from [cyclestreets.net](cyclestreets.net)
    -   Fastest
    -   Balanced
    -   Quietest

[Go to Releases](https://github.com/U-Shift/cyclingpotential-hack/releases/)

Topics
------

We have developed ideas for a few hack topics:

-   Cycling uptake functions
-   Estimating flow between Origins and Destinations using spatial interaction models
-   Routing algorithms and routing services - hilliness integration?
-   Use of counting points data
-   Minimum requirements for a PCT at any place
-   How cycling responds locally to different intervention types, e.g. based on cycle counter data

Any further ideas very welcome, feel free to bring your own!

How to sign up
--------------

To sign-up complete [this](https://ushift.tecnico.ulisboa.pt/~ushift.daemon/limesurvey/629464) application form.

Any questions?
--------------

Feel free to ask any questions related to this hackathon on the [issue tracker](https://github.com/U-Shift/cyclingpotential-hack/issues).
