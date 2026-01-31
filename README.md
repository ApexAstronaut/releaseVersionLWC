# Salesforce System Release Info LWC

A Lightning Web Component that displays the current instance, release version, and maintenance window for your Salesforce Org by querying the public Salesforce Trust API.

## Features
- 🚀 Auto-detects Salesforce Instance (e.g., USA1052, NA123).
- 🚦 Dynamic Status Indicators (Active/Maintenance/Error).
- 🛡️ "Hyperforce Aware": Handles missing release version data with a witty fallback message.

## Setup Instructions
1. Deploy the code to your org.
<a href="https://githubsfdeploy.herokuapp.com?owner=ApexAstronaut&repo=releaseVersionLWC&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
2. The Remote Site Setting (`SalesforceTrustAPI`) should be deployed automatically.
   - If not, go to **Setup > Remote Site Settings** and add `https://api.status.salesforce.com`.
3. Add the **System Release Info** component to your **Home Page** via the Lightning App Builder.