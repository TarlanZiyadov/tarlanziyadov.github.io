---
layout: post
title: "POWER OF SLACK APPS IN AUTOMATION"
date: 2022-09-11 23:45:40 +0200
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

![Power of slack apps in automation](/assets/images/articles/power_of_slack_app_in_automation/power_of_slack_app_in_automation.jpg)

## **Slack as an Automation Tool**

Let’s start with the concept of Slack. Slack is a great messenger for developers, and recently they implemented a new feature called **Huddle**. Huddle enables collaboration with developers without the need to be physically side by side.

On the other hand, channels themselves are great — they feel like a space where you can share information with the team as well as have simple chats.

Slack also allows editing channels, for example by adding **Incoming Webhooks**.

> Incoming Webhooks are a simple way to post messages from external sources into Slack. They use normal HTTP requests with a JSON payload, which includes the message and a few other optional details described later.

![Incoming webhooks](/assets/images/articles/power_of_slack_app_in_automation/incoming_webhooks.png)

This feature offers a great way to send messages or notifications to a specific Slack channel.

To get notifications from other resources, you need to integrate an app called **Incoming WebHooks** into the chosen Slack channel and follow basic documentation on how to send JSON data to the channel using the endpoint provided by Slack.

Messages sent via this feature are quite basic, with only a few options for customization.

However, this feature has unfortunately been deprecated, which means Slack could remove it at any time.

Therefore, I recommend checking if you are using Incoming WebHooks — it might be time to make some changes and start using **Slack apps** instead.

Now, here come the new great Slack apps!

---

## **Slack Apps**

Since **Incoming WebHooks** are deprecated, Slack introduced a new feature called **Slack Apps**.  
(Read more on the [official Slack website](https://api.slack.com/apps).)

With Slack Apps, you get full control over notifications—not only the payload itself but also the interactivity with them. The concept is similar to Incoming WebHooks but with much more flexibility:

- You can customize the payload extensively.
- You can allow users to interact with notifications by providing options.
- You can add data to the notifications.

For example, you can send a notification asking, **"Do you want to start the pipeline?"** The user can then choose **Yes** or **No**. When the user selects an option, Slack sends an API request to your backend endpoint _(which I will explain next)_. Based on the payload received, your backend can trigger actions like starting a test pipeline.

For instance, [CircleCI](https://circleci.com/docs/api/v2/) provides API endpoints to trigger pipelines programmatically.

It’s also good to know that every time a user interacts with the notification you sent to the channel, Slack will send a request to the endpoint you provide.

![Interactivity and shortcuts slack app](/assets/images/articles/power_of_slack_app_in_automation/interactivity_shortcuts_slack_app.png)

---

Beside interacting with, for example, a pipeline, you can also send a response back to the Slack channel.

In the payload received from Slack, you will find important information such as:

- `channel.id` — the ID of the channel where the interaction happened
- `message.ts` — the timestamp of the original message

These are essential if you want to **post a new message** or **update the original notification**.

For example, when a user selects the **"Yes"** option to trigger a pipeline, your backend can:

1. Send a message back to the channel confirming the action.
2. Modify the original notification (e.g., close it or update the text) to indicate that the backend received the request and the pipeline will be triggered.

This improves user feedback and trust in the automation process.

---

## **Building with Block Kit**

Notification you will send to the channels is basically json objects. You can build them into single json object and send it to the channel.

Slack provides a visual and interactive builder called **Block Kit Builder** to help you structure these JSON blocks easily.  
👉 [Start building with Block Kit](https://api.slack.com/tools/block-kit-builder)

Basic json block with link button in it:

```javascript
{
"type": "section",
    "text": {
       "type": "mrkdwn",
       "text": "New Paid Time Off request from<example.com|FredEnriquez>\n\n<https://example.com|View request>"
     }
}
```

---

## **Back-end Service**

To enable interaction with Slack notifications, you need to build an **API service**—or add an additional endpoint to an existing service—that can receive requests from Slack.

There’s nothing fancy required here. A **basic API** will work just fine. The main responsibilities of this service include:

- **Receiving incoming requests from Slack**
- **Parsing the JSON payload**
- **Making decisions based on the payload**
- **Sending responses or triggering actions (e.g., pipelines)**

Without this backend service, you can only send static messages to a Slack channel and **won’t be able to use interactive features** of Slack Apps. That means you’re limited to the same functionality as deprecated **Incoming WebHooks**.

> 📌 **Tip:** Slack's interaction payloads can be large and nested.  
> Make sure your backend is well-structured to handle:
>
> - Parsing large JSON payloads
> - Accessing nested values (like action types or user input)
> - Handling various Slack event types (block_actions, message_actions, etc.)

Using a clean structure in your backend logic will make your code easier to scale and debug.

---

## **Postman as Mock Server**

Unfortunately, you can't directly test Slack's incoming requests to a **localhost** URL. Slack requires a publicly accessible HTTPS endpoint for sending interaction payloads—so local development is a bit tricky.

But there's a solution: **Postman Mock Server**.

You can create a mock server in Postman and use the URL it provides as the **Request URL** in your Slack App settings. This way, every time you interact with a Slack notification, Slack sends the payload to the Postman mock server.

### Here's how it works:

1. **Create a Mock Server** in Postman.
2. Add the **mock server URL** as the request handler in your Slack App (under Interactivity settings).
3. Interact with your Slack message (e.g., click a button).
4. Postman receives the incoming request and displays the full JSON payload.
5. From Postman, you can manually or programmatically **forward that payload** to your local server for development and testing.

> ⚠️ This only works if you're using **Postman workspaces**, since the mock server is hosted online and needs to be shared with Slack.

![Postman mock server](/assets/images/articles/power_of_slack_app_in_automation/postman_mock_server.png)

To get started with Slack interactivity and Postman mock servers, you can follow the **official Postman documentation** linked below.

👉 [Full guide to Postman mock servers](https://learning.postman.com/docs/designing-and-developing-your-api/mocking-data/mocking-with-examples/)

---

## **Display information**

Since Slack apps is an app in the slack therefore you can give it a name as well add description to let your users know what does your app do.

![Slack app display information](/assets/images/articles/power_of_slack_app_in_automation/slack_app_display_information.png)

---

## **Test Automation**

We’ve reached the final part of this article. Now that you understand how **Slack Apps** work, let’s explore how to use them in the context of **test automation**.

With Slack apps, you can send interactive notifications **directly from your automated test runs** to a Slack channel—and let your team members interact with them in real time.

### Common Use Cases:

- ✅ **Rerun Tests from Slack**  
  Include pipeline metadata (e.g., pipeline ID or branch info) in the payload sent by your automated test.  
  When a team member interacts with the notification (e.g., clicks "Rerun"), the backend captures the event, reads the data, and triggers a pipeline rerun.

- 📊 **Post Test Reports**  
  After each test run, you can send a summary or detailed report to a channel.  
  Allow team members to review and confirm results, then interact with the message (e.g., "Close Report") to archive or acknowledge the run.

> 🔧 **It’s entirely up to you** how to design the messages using [Block Kit](https://api.slack.com/block-kit) and how much interactivity to include. Be creative, but stay practical.

---

## **Conclusion**

Hope this article helped you and made testing a bit more fun!

Exploring how tools like **Slack Apps** and **mock servers** can integrate with your automation efforts opens up exciting new possibilities for smarter, more interactive testing.

Thanks for reading, and happy testing! 🎉
