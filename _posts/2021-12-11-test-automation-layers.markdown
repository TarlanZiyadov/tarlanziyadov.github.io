---
layout: post
title: "TEST AUTOMATION LAYERS"
date: 2021-12-11 23:45:40 +0200
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

![Test automation layers](/assets/images/articles/test_automation_layers/test_automation_layers.jpg)

> Automation of tests can be very helpful **only if** you choose the right implementation techniques **and** the right tools.
>
> When should you start building and integrating automation tests?  
> If developers want to ensure quality in the product code, **unit tests** are a crucial layer in the development process.  
> They help catch issues early and serve as a solid foundation before moving on to integration or end-to-end tests.

## **Unit Tests**

Unit tests are mainly written by developers at the same time they write the production code. The main focus of these tests is to verify that the production code handles issues correctly and returns the expected values.

Overall, unit tests check if the code maintains good quality. They work by sending input data to methods and asserting the output values returned.

## **Integration Tests (API Tests)**

Integration tests, also known as API tests, are developed by both developers and testers, though it’s less common for testers to write them due to the required strong backend knowledge.

API tests operate by sending requests to endpoints and verifying the response data.

In some cases, it’s very helpful to include API tests as part of UI automation, especially when test data is needed for UI tests.

I will share examples of this approach in future articles.

---

## **UI Automation Test**

UI automation tests are the last layer of automation. These tests are often developed by testers with programming skills.

### Purpose of UI Automation Tests

- To check the final product through the UI.
- Verify that all integrations work correctly.
- Ensure that user interactions, such as order flows, behave as expected.

### Main Focus

- Save time on regression testing.
- Every time a new feature is deployed to the test environment, testers need to verify if the changes negatively impact existing functionalities.
- Manual testing of different UI flows can be time-consuming.

### Benefits of UI Automation

- Automate repetitive checks after every deployment.
- Allow testers to focus more on exploratory testing and manual testing of new features.
