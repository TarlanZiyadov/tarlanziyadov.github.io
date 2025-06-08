---
layout: post
title: "WHAT IS SITEMAP AND HOW IT'S WORKS?"
date: 2022-06-12 23:45:40 +0200
categories: Development
---

<style>
.button-back {
  background-color: #f7f7f7;
  color: #333;
  padding: 0.3em 0.7em;
  border-radius: 4px;
  text-decoration: none;
  border: 1px solid #ddd;
  font-weight: 500;
  font-size: 0.9rem;
  text-align: center;
  display: inline-block;
  margin-bottom: 0.8em;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.button-back:hover,
.button-back:focus {
  background-color: #e0e0e0;
  text-decoration: none;
}
</style>

<a href="{{ site.baseurl }}/"
onclick="window.history.back(); return false;"
class="button-back">
<span style="font-size: 0.9rem;">←</span> Back </a>

![What is site map](/assets/images/articles/what_is_sitemap/what_is_sitemap.jpg)

## **What is Sitemap?**

A sitemap is a catalog of the website pages provided to search engines in order to index the website.

In simple words, you are telling the search engine what you have on your website,  
so if users search for something similar, they will find it in the search engine results.

Let’s say your website has 10 blog posts.  
One of the blogs is named **"How to build a car?"**

In this case, your blog is only visible if a user searches for it inside your website or if you share it directly.  
But imagine how many people search for similar content daily on Google.

The issue here is that none of them will see your blog post on Google unless you tell Google that you have information about building a car on your website.

Therefore, Google needs a file which contains links from your website, including the names of your blog posts.  
This file is called a **Sitemap**, and it is often in **XML** (Extensible Markup Language) format,  
but it can also be in a regular **TXT** (text document) format.

---

## **How to Generate a Sitemap?**

# Manual Generation of the Sitemap

Sitemaps can be generated manually or automatically.

If your website’s content does not change dynamically by many users, it’s usually enough to generate it manually.

To do this, you need to create an XML file and add links from your pages to this file.

For example, look at this XML block:

```xml
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:image="http://www.google.com/schemas/sitemap-image/1.1">
  <url>
    <loc>https://example.com/articles/read?article=How to build a car?</loc>
    <lastmod>2022-06-11</lastmod>
    <changefreq>daily</changefreq>
    <priority>1.0</priority>
  </url>
</urlset>
```

As you see, we have the location of the blog post, when it's modified, change frequencies, and priority. The last two are only for your page and will not affect results in search engines.

For example, priority is used to compare the content inside the website and it can be between 0.0 and 1.0. So if we save this file as an XML file and provide it to Google, then you will have a higher chance to be seen in search results.

This way, users can find your blog post on Google.

---

## **Automatic Generation of the Sitemap**

Well, generating a sitemap manually is very easy, but how about automatic generation of the sitemap? This part is very important if your website has dynamically generated content — meaning that users can log in and share content.

Creating a sitemap manually then becomes very tricky, since you have to go through all the content shared on the website and add it to the XML file. This is a huge amount of work if your website content changes daily.

To skip the manual part, you will need to build an endpoint in your back-end service and provide it to the search engine through your client-side application. _(I will explain later why you should not provide the endpoint directly to the search engine.)_

In the back-end, you can go through the shared content in your application and parse it into an XML file. Most content is often saved in a database, so extract it from the database and parse it — for example with `js2xmlparser` for Node.js — and save it as an XML file.

---

### Take a look at this code block:

```javascript
const js2xmlparser = require("js2xmlparser");
const moment = require("moment");
const rootUrl = {};
const data = [];
let today = moment();
today = today.format("YYYY-MM-DD");

databaseObject.forEach((articleName) => {
  rootUrl.loc = `https://example.com/article/details?article=${articleName}`;
  rootUrl.lastmod = today;
  rootUrl.changefreq = "daily";
  rootUrl.priority = "1.0";
  data.push(rootUrl);
});

const col = {
  "@": {
    xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9",
    "xmlns:image": "http://www.google.com/schemas/sitemap-image/1.1",
  },
  url: data,
};

const xml = js2xmlparser.parse("urlset", col);
```

So now you can save

```javascript
const xml
```

to a file or can send it back to client site and save it there. If you using server-less back-end then you can save it to the bucket storage and then retrieve _storage URL_ and send it data to the client side as application/xml as array buffer for example

```javascript
res.send(Buffer.from(resp.data, "utf-8"));
```

where

```javascript
resp.data;
```

is array buffer you can get from storage bucket with for example **Axios GET request**. Remember that I said we may not provide back-end endpoint to search engine?

Well it's because of the security reason in **Google search console** and I will explain you how **Google search console** work later. Basically search console accepts only link to you sitemap in your domain and not in other since often back-end services has different domain than your client side.

So basically what you need is save the response you got from back-end into an XML file in client side and provide URL to it to the search console. Often this data stored in the public folder. For example _https://example.com/sitemap.xml_ .

_So whats next?_ Now we will take a short look on how **Google search engine** works.

---

# **Google search console**

First you need to have an google account and login to the [Google Search Console](https://search.google.com/search-console). Then you need to add resource which is your website as shown in the screenshot down below.

![Google console search](/assets/images/articles/what_is_sitemap/google_console_search.png)

When you added your website and followed steps then you should have menu items on the left side as down below.

![Google console meny](/assets/images/articles/what_is_sitemap/google_console_meny.png)

Here we choose Sitemaps and then you will see the view where you can enter sitemap url.

![Google console sitemap](/assets/images/articles/what_is_sitemap/google_console_sitemaps.png)

So now when you saved your **XML** file and have the **URL** then can we add it and provide search engine catalog of the your website.

After these steps don't forget to review your URL. Choose the menu item called **Review of URL**. Congrats if your page pass the Google search engine tests then your website will be indexed.
