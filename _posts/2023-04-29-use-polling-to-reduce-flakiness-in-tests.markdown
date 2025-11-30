---
layout: post
title: "USE POLLING TO REDUCE FLAKINESS IN E2E TESTS"
date: 2023-04-29 23:45:40 +0200
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

![Use polling to reduce flakiness](/assets/images/articles/use_poling_to_reduce_flakiness/use_poling_to_reduce_flakiness.jpg)

## **Introduction**

In this short article I will explain when and why use polling endpoints in end-to-end tests build by Cypress but this even can be implemented to the Selenium or Playwright. Given code examples can be done in very different ways so it's up to the developer to decide how to implement the solution.

# **When and Why**

In Cypress I use generally [Intercept](https://docs.cypress.io/api/commands/intercept) and [Spy](https://docs.cypress.io/api/commands/spy) at the same time to wait for the endpoints and verify that client side and back-end are connected and work as expected with example by [Gleb Bahmutov](https://glebbahmutov.com/blog/).

In the beforeEach hook in Cypress we add:

```javascript
cy.intercept(`/api/endpoint/**`, cy.spy().as("endpointRequest")).as("endpoint");
```

And then we can create one function to use in the entire framework [(dry principle)](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself) by just sending endpoint name to this function:

```javascript
const wait = ({ alias }) => {
  cy.get(`@{alias}Request`).should(have.been.called);
  cy.wait(`@{alias}`).then((result) => {
    if (!result.response.status.toString().startsWith(2))
      throw Error(`Could not add item {result.response}`);
  });
};
```

finally in the tests we import our function and verify that e.g when button is clicked then the request is occured and response was succesfully:

```javascript
it("When click on the send button", () => {
  mainPage.elements.button("send").click();
  intercept.wait({ alias: "endpoint" });
});
```

---

By using the above example, we can avoid using hard coded [waits](https://docs.cypress.io/api/commands/wait) or [thread.sleeps](https://testsigma.com/blog/selenium-sleep/) that rely on guessing the time. Such guesses make your framework flaky over time and add unnecessary time to the runtime. However, sometimes in tests we need to wait for data to be generated in the back-end.

This situation can occur, for example, when a user clicks the send button and an event is fired in the back-end. Based on this event, another service will start generating data that will eventually be available on the client side.

Of course, we could guess and add hard coded waits, but data generation can sometimes take shorter or longer than expected, so our waits would not be explicit waits, which are generally recommended.

So then, what’s next? Here comes [polling](https://www.ibm.com/docs/en/networkmanager/4.2.0?topic=polling-network).

---

## **Polling endpoints**

Polling endpoints are mostly used in back-end microservices to listen for some endpoints and e.g. send notifications or generate data. But nothing stops QA from using different technologies to make end-to-end tests more reliable and reduce maintenance time of the framework.

So, in cases where I have to wait for some data generation, I implement polling endpoints as an explicit wait.

In Cypress v10 and above, we can add polling to the Node environment in the `cypress.config` file under `e2e` as a task.

To poll endpoints we will use Axios, so make sure to install the npm package for Axios.

```javascript
pollEndpoint({ endpoint, token, interval }) {
      const generatedData= []
      return new Promise((resolve, reject) => {
          const poll = setInterval(() => {
             axios({
                method: 'GET',
                url: endpoint,
                headers: {
                  Authorization: `Bearer ${token}`
                }
              }).then((response) => {
                if (response.data) {
                  response.data.generated.forEach(item=> {
                    if(generatedData.indexOf(item) === -1) generatedData.push(item)
                  })
                }
              }).catch(() => {
                  clearInterval(poll)
                  resolve(false)
              }).finally(() => {
                  if (generatedData.length === 4
                    && generatedData.includes('itemName')) {
                    clearInterval(poll)
                    resolve(true)
                  }})
          }, interval)
    })
}
```

Then in the tests we will wait for the data to be generated:

```javascript
it(
  "Then I verify items are generated",
  {
    retries: configuration.TestRetryCount,
  },
  () => {
    cy.task("pollEndpoint", {
      endpoint: `test`,
      token: `token`,
      interval: 10000,
    }).then((itemsReady) => {
      if (!itemsReady) {
        throw Error("Could not find the items!");
      }
    });
  }
);
```

---

Finally, some magic you avoided implicit waits and have explicit waits instead. By doing this, your team can even improve the time for data generation based on the report you provide them.

Don’t forget that Cypress has a default timeout for tests of 60 seconds, which can be changed in the config.

So, if no data is found during those 60 seconds, the test will fail. But if data is found while polling, the test will pass immediately without any further waiting.

![Magic gif egg](/assets/images/articles/use_poling_to_reduce_flakiness/gif_magic_use_polling.gif)

---

## **Conclusion**

The above example is specifically built for [Cypress](https://docs.cypress.io/app/get-started/why-cypress), but with some refactoring it can also be applied to [Selenium](https://www.selenium.dev/) or [Playwright](https://playwright.dev/).

Also, feel free to check out my other articles related to testing and test automation.
