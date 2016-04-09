This is a simple iOS app to manage trips. It is just for demo purposes, built using 
the loopback sdk. It allows to:

* create an account and log in
* when logged in, user can see, edit and delete trips he entered
* it has three types of user roles with different permission levels 
..* regular user is able to CRUD on his owned records, 
..* a user manager is able to CRUD users,
..* an admin is able to CRUD on all records and users
* when a trip is entered, it has Destination, StartDate, EndDate, Comment
* when displayed, each entry has also day count to trip start (only for future trips)
* user can filter trips
* print travel plan for next month in a pdf


This app back end is available [here](https://github.com/sanandrea/TripManagerServer)



LICENSE
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.