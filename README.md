# Salesforce System Release Info LWC ℹ️

![Salesforce](https://img.shields.io/badge/Platform-Salesforce-00A1E0.svg) ![LWC](https://img.shields.io/badge/Framework-LWC-orange.svg)

A Lightning Web Component that displays your Salesforce Org's current **Instance Name**, **Release Version**, and **Maintenance Window** by querying the public [Salesforce Trust API](https://api.status.salesforce.com/).

---

## 👀 Preview

<img width="993" height="178" alt="PNG image" src="https://github.com/user-attachments/assets/575dd007-706b-4997-917b-39d201f771cd" />

---

## ✨ Features

* 🚀 **Auto-Detection:** Automatically finds your Salesforce Instance (e.g., `USA1052`, `NA123`).
* 🕵️ **Smart Search Fallback:** If a direct lookup fails (common with Hyperforce), it uses a fuzzy search to find the correct instance data.
* 🚦 **Visual Status:** Dynamic Green/Red indicators for system status.
* 🕒 **Maintenance Windows:** Displays your upcoming maintenance window directly on the Home Page.

---

## 📦 Installation

### Option 1: One-Click Install (Recommended)
You can deploy this component, the Apex classes, and the required Remote Site Settings to your Sandbox or Production org with a single click.

<a href="https://githubsfdeploy.herokuapp.com?owner=ApexAstronaut&repo=releaseVersionLWC&ref=main">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>

### Option 2: Manual Install (SFDX)
If you prefer using the command line:

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/ApexAstronaut/releaseVersionLWC.git](https://github.com/ApexAstronaut/releaseVersionLWC.git)
    ```
2.  **Deploy to your org:**
    ```bash
    sf project deploy start
    ```

---

## ⚙️ Post-Installation Setup

Once deployed, follow these steps to add the component to your users' view:

1.  **Add to Page Layout:**
    * Navigate to your **Home Page** in Salesforce.
    * Click the **Gear Icon ⚙️** > **Edit Page**.
    * Search for `systemReleaseInfo` in the component list (left sidebar).
    * Drag and drop it onto the page.
    * Click **Save** and **Activate**.

2.  **Verify Remote Site Settings:**
    * The installation *automatically* deploys a Remote Site Setting named `SalesforceTrustAPI`.
    * If you see an error in the component, verify this setting exists in **Setup > Remote Site Settings** with the URL: `https://api.status.salesforce.com`.

---

### 📝 Notes
* This component requires the **Salesforce Trust API** to be accessible from your org.
* Designed for Lightning Experience (Home Pages / App Pages / Record Pages).
* If your ORG is on a Hyperforce Instance, the Trust API will not return your current release version. (This is a Salesforce limitation)
