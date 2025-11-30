---
layout: post
title: "TIME TO TALK ABOUT FLAKY TESTS"
date: 2023-01-02 23:45:40 +0200
categories: QA
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

![Time to talk about flaky tests](/assets/images/articles/time_to_talk_about_flaky_tests/time_to_talk_about_flaky_tests.jpg)

## **What is a Flaky Test?**

Let me at least try to explain what a flaky test is, so if you are new to automation, you can better understand what this article is about.

Flaky tests are automated test cases that fail without any code change in the automation itself, nor any code change in the core application that your automation is testing.

For example, let’s say you build a test case that verifies the "Welcome" text on the landing page. You run your script and get an output that indicates your automation successfully found the text and the assertion passed.

After this, you push your code to the repository and let your tests run daily or every time new code is merged into the core application. You go home happy.

The next day you come back and see that the test case you built yesterday has failed. You investigate whether there is a new bug in the core app. If you have logs related to the core app, it’s important to check them because there might be a bug that occurs only under certain circumstances.

Let’s say you don’t find any new bugs. Then you investigate if there were any new changes in the core app again, nothing new.

You then run your tests locally and your build passes successfully. You decide to run the test two more times to see if it’s flaky, and boom one of the three runs fails.

You check the test result and, depending on the framework, you get an error message. For example, your script couldn’t find an element in the DOM. You check the element and it’s the same element as yesterday.

Could this indicate a flaky test? Most likely, yes.

You need to build your test case more reliably by, for example, waiting for some response from the backend or verifying that you are on the correct window before doing your assertion.

[Read Eric Avidon’s article on flaky tests](https://www.techtarget.com/whatis/definition/flaky-test) for more insights.

---

## **What Can Cause a Test to Be Flaky?**

### Timeout Issue

For example, you open the landing page and the "Welcome" text appears only after a response is received from the back-end. In this case, you need to wait for the back-end request before doing the assertion.  
**Recommendation:** Avoid using `sleep` or fixed waits by seconds. Instead, monitor responses from the back-end and wait for them. Cypress’s [`intercept`](https://docs.cypress.io/api/commands/intercept#Waiting-on-a-request) is great for this.  
[Read more about Cypress intercept waits](https://docs.cypress.io/api/commands/intercept#Waiting-on-a-request).

### Scroll Issue

For example, you open the landing page and wait for the "Welcome" text, but the text is in the page footer out of view for the automation tool. You need to scroll to the element before asserting on it.

### Cookie Issue

For example, when you open the landing page and cookies saved for the page get removed, the back-end might return a `401` status or some other response without the "Welcome" text in the body. Your assertion will fail.  
**Solution:** Use sessions or save cookies for each test to ensure cookies are always available in request headers.

### More Than One Element Matches

If you don’t have a unique element ID for assertion, you might rely on class names or text to find elements in the DOM. This can cause your script to find multiple elements with the same text or class, some of which may not contain the expected "Welcome" text.  
**Advice:** Ask developers to add unique element IDs before new features are developed to avoid flaky tests.

### Lack of Good Code Review

Good code reviews help reduce flaky tests. For example, loops or timing-dependent code can introduce flakiness. If you use timestamps for generating data or assertions, ensure the time retrieval is reliable.

### Other Unknown Issues

There can be unexpected behaviors in the core app that cause flakiness.

### Other Cases (Network Issues, Test Data Issues, etc.)

Sometimes, simply rerunning a specific test case can solve such issues.  
Cypress has built-in test reruns which have worked well for me.  
[Read about test retries for Cypress](https://docs.cypress.io/app/guides/test-retries#How-It-Works).

---

## **Can We Automate Detection of Flaky Tests?**

There might be a potential solution for this, such as detecting failed tests and saving them within a given timeframe in a database, then verifying every time tests fail if they match the saved data.

Unfortunately, I don’t have any results yet, but I will come back with another topic on this soon.

So, subscribe and turn on notifications so you don’t miss it!

---

## **Conclusion**

![Time to talk about flaky tests conclusion](/assets/images/articles/time_to_talk_about_flaky_tests/time_to_talk_flaky_tests_conclusion.jpg)
[Photo by Simon Abrams](https://unsplash.com/@flysi3000)

Flaky tests are never fun and can become a headache for developers. They can take time to understand and also time to properly solve.

If you find a test to be flaky, put it into quarantine meaning remove it from the main test pipeline so your tests don’t fail because of it. Take your time to fix it in a development pipeline so your teammates can trust your automation.

This way, your automation remains trusted and does not give false results based on the state of the core app.

Fixing flaky tests is part of the work, so I don’t see it as a problem but rather as necessary cleanup.

In the automation lifecycle, there will always be flaky tests since we learn from the mistakes we make.
