---
layout: post
title: "HOW TO BUILD CONTEXT DRIVEN END-TO-END TESTS"
date: 2024-12-20 23:45:40 +0200
categories: QA
---

![Build context driven tests](/assets/images/articles/build_context_driven_tests/build_context_driven_tests.jpg)

## **Why context driven end-to-end tests?**

In this short article I will show you how to implement contexts to the end-to-end tests so you can save time, make adjustment fast and easy as well be able to run tests parallel. Examples shown will be simple but with the logic can be applied to the more complex tests.

First, what is context driven testing? It is simple — given different context, test the end result. So our end-to-end tests need to be able to take context and based on the context run tests. These tests will have mostly one way flow and only context will be different.

So imagine you have 10 different contexts, e.g. 10 different item cards with the same code structure and flow in the webpage but different content in it. This might even include different event verification for each of the cards.

So to test all 10 cases you might want to create multiple tests but wait — why repeat the same code 10 times? It will become unmaintainable by time and every change will make you stop doing what you like much — building regression tests. So therefore we will implement contexts to our tests.

We can as well run our contexts parallel with [cypress-parallel](https://www.npmjs.com/package/cypress-parallel).

---

## **Solution**

First we need to define our folder structure since it is very important part of the project. Take a look to the screenshot:

![Folder structure](/assets/images/articles/build_context_driven_tests/folder_structure.png)

Here we have contexts folder which will contain our contexts for different flows and under tests folder we have the actual tests.

We will start with the tests folder _search_Item.js_ file. This file contains our tests that we will reuse in different contexts. So take a look to the example:

```javascript
/* eslint-disable import/prefer-default-export */
import contents from "../../pageObjects/contents";

export function tests({ item, content, text }) {
  describe(`Verify ${item}`, () => {
    it(`When I go to ${item} page`, () => {
      if (content === "softwares") {
        contents.navigateToContent({
          content,
        });
      }
    });

    it(`When I open ${item}`, () => {
      contents.openItem({
        item,
      });
    });

    it(`Then I verify ${item} text`, () => {
      if (content === "articles") {
        contents.verifyArticle({
          text,
        });
      }

      if (content === "softwares") {
        contents.verifySoftware({
          text,
        });
      }
    });
  });
}
```

We basically export our tests as a function and it accepts some parameters which we pass to the tests so we can even have dynamically test naming.

**Note** here if you have eslint then it will not like _exporting function_ and will recommend export it as default but unfortunatly in [Cypress.io](https://www.cypress.io/) it won't work as eslint suggest so you can disable eslint rule for the test.

---

Next we continue with the _contents.js_ file in the pageObjects folder as an example here so you know how everything is set up.

```javascript
const elements = {
  menu: (content) =>
    cy.get('ul[id="selectContent"]').contains(content.toLowerCase()),
  card: (item) =>
    cy
      .get(`[id="headerText_${item.replace(/\s+/g, "").toUpperCase()}"]`)
      .contains(item.toUpperCase()),
  articleText: (text) => cy.get('div[id="articleText"]').contains(text),
  softwareText: (text) =>
    cy.get('div[id="softwareDescription"]').contains(text),
};

const navigateToContent = ({ content }) => {
  elements.menu(content).scrollIntoView().should("be.visible").click();
};

const openItem = ({ item }) => {
  elements
    .card(item)
    .scrollIntoView()
    .should("be.visible")
    .parent()
    .parent()
    .click();
};

const verifyArticle = ({ text }) => {
  elements.articleText(text).scrollIntoView().should("be.visible");
};

const verifySoftware = ({ text }) => {
  elements.softwareText(text).scrollIntoView().should("be.visible");
};

export default {
  navigateToContent,
  openItem,
  verifyArticle,
  verifySoftware,
};
```

We skip fixtures folder but good to mention that we have content texts(copy) stored as json in that folder and we export them in the test to make assertion.

We're making very basic assertions in this tests since this article is about contexts and not about assertions, but you got the idea.

---

So now let's take a look to the contexts folder. First we will go througt _run_Search_Article.spec.js_ file which is context for verifying articles.

```javascript
import { tests } from "../../tests/searchItems/search_Item";
import articles from "../../../fixtures/testData/articles.json";

describe("Verify article", () => {
  context("Test", () => {
    tests({
      item: "POWER OF SLACK APPS IN AUTOMATION",
      content: "articles",
      text: articles.POWER_OF_SLACK_APPS_IN_AUTOMATION,
    });
  });
});
```

As you can see we have context as 'Test' but you can name it as you want. We pass the values to our test and this is the file that Cypress will run.

![Cypress spec contexts](/assets/images/articles/build_context_driven_tests/cypress_spec_contexts.png)

And here we have the result:

![Context run articles](/assets/images/articles/build_context_driven_tests/context_run_articles.png)

---

Same as well with the _run_Search_Softwares.spec.js_ file.

```javascript
import { tests } from "../../tests/searchItems/search_Item";
import softwares from "../../../fixtures/testData/softwares.json";

describe("Verify software", () => {
  context("Test", () => {
    tests({
      item: "HELPERPLUSPLUS",
      content: "softwares",
      text: softwares.HELPERPLUSPLUS,
    });
  });
});
```

And the result:

![Context run softwares](/assets/images/articles/build_context_driven_tests/context_run_softwares.png)

---

## **Conclusion**

We can now run different article and software verification tests with only one test flow but in different contexts. Hope I could help you to reduce code and have more structured regressions tests. Happy coding :)
