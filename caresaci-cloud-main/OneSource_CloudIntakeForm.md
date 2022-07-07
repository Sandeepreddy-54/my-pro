## Section 1: Product Summary

| Product Name | Ask ID          | Technical Lead | PMO Lead       |Cloud Platform | Business Unit |
| ------------ | --------------- | -------------- | -------------- | -------------- | ---------------- |
| OneSource Database  | AIDE_0074943 | Praveen Chandra  | Esther Martinez      | Azure |   OptumCare     |


#

| Table of Contents |
| ----------------- |
| [Section 1: General](#section-1-general) |
| [Section 2: Data Governance](#section-2-data-governance) |
| [Section 3: Code Delivery and Management](#section-3-code-delivery-and-management) |
| [Section 4: Architecture Summary](#section-4-architecture-summary) |
| [Section 5: Network Summary](#section-5-network-summary) |
| [Section 6: Security Criteria](#section-6-security-criteria) |
| [Section 7: Circumstances and Exceptions](#section-7-circumstances-and-exceptions)

**NOTE**:  [Helpful Links](https://cloud.optum.com/docs/intake/intake-links)
- All links to helpful documents are now located in a single, convenient location for your use.  
- Please find all links to documents, lists of appropriate guidance, or authorized approvers on our Intake Website located on this page: [Helpful Links](https://cloud.optum.com/docs/intake/intake-links)  

## Section 1: General

### General Intake

#### Required when submitting a request for a Public Cloud account:

- [ ] Read and complete ALL sections, do not remove any sections of the document.
- [ ] The completed copy of this document must be placed in a GitHub project repo, not a personal repo
- [ ] The document content must be submitted in Markdown (.md) format for easy consumption and updates
- [ ] Use the latest version of this document even if your prior requests used an older version
  -  The latest version can be found here: https://github.optum.com/healthcarecloud/intake/
  -  Do not remove any of the pre-existing template guidance content
- [ ] Obtain prior approval from your business segment chief architect for the effort, if required by your Line of Business

#### Optional but will help accelerate your request for a Public Cloud account:
- Consider Assessments or Frameworks to help you on your cloud journey
- For Prod requests,
   - use Demeter to find Secrets and passwords in your repo prior to making the intake request
   - make sure to clean up your Azure nonProd subscription of any extraneous resources and components

#### A note about Approved Cloud Components and Tech Landscape / PADU
Please note that you will need to validate that all components that you choose to implement are in Optum's [Tech Landscape (PADU)](https://techlandscape.optum.com/) with the following Ratings:
* NonProduction:  Must be rated as Preferred (P), Acceptable (A) or Emerging (E)
* Production. Must be rated as Preferred (P) or Acceptable (A)
* Using Discouraged or Unacceptable components may result in having to re-submit your request, and will delay your Intake review.  
 
For assistance in identifying alternatives, please [Connect with a Vanguard Specialist](https://hccvanguard.ideas.aha.io/ideas/new)!

### Description


> **Guidance**: A well thought-out description of your application will help us to better understand the use, architecture, and infrastructure you plan on deploying.  Use this section to describe your application, its use case(s), and why you want to house it in the public cloud as opposed to any other platform. Where possible please include the Business Platform, Business Product, Capability or Utility information.
----------------------------------------

The OneSource database application is a UI for database that houses non-PHI member information such as Address, Phone, and Email.

The goal of the project OneSource Database is to maintain, update and track the changes in the member's contact information so that the authorized users have a central place where they can get this information to reach out to the members.

OneSource Database maintains the member details like GMPI id, date of birth, Phone number, email address and address details etc at one place. The portal enables the users to lookup details for any member using GMPI id, first name, last name and so on. 

Users can modify the member's contact information through the portal, mark any contact information as invalid if they were not able to reach the member using the information and update the overall outreach status for the member.






----------------------------------------

#
### Business Segment Chief Architect Awareness

> **Guidance**: Use this section to provide the proof of approval from the Business Segment Chief Architect (or listed delegate) - if required by your Line of Business.
> * Embed a screenshot image of an email from your Business Segment Architect which provides dated confirmation of their review and approval of this Public Cloud request.
> * Please ensure that the approval is dated within 30 days of your submission, and that the date of the eMail is visible.
> * Note:  Separate approvals are needed for each environment [nonProd / Prod] and should be noted in the Chief Architect approval statement.

----------------------------------------
<Share the Chief Architect approval information here>

Business Segment Chief Architect:  <name>

![Approval-image](https://github.optum.com/Org-Wellmed/caresaci-cloud/blob/main/ChiefArchitectApproval.png)





----------------------------------------

#
### User Details

> **Guidance**: Understanding the users of your Application will help us to guide you in the best approach to securing your infrastructure.  Providing this information will allow the Intake team to guide you on your Architecture, Network and Security reviews.  Use this section to describe your application's users.
> Some things to think about (non-exhaustive):
> - Who are your users?
> - Are they internal (UHG Employees), external, or a mix of both?
> - Please indicate the Identity domains (Onprem MS, AzureAD, HSID, OneHealthcare ID, etc) used to authenticate the internal/external users
> - Describe how you are authenticating and authorizing users
--------------------
>- WellMed users ~ 700 users
>- WellMed internal only
>- OneHealthcare ID
>- Users are authenticated via OneHealthcare ID identity provider. The access token obtained from OneHealthcare ID will be used to authenticate users to OneSource application.
	The users must be marked active in the OneSource Database in order to login successfully .
	Once the users are logged in, there is no roles based authorization as the same is not required as confirmed from the business as well i.e. all authenticated users should have read/write privileges once they have successfully logged in.






----------------------------------------

### Workload Placement use case

> **Guidance**: While public cloud is often an excellent choice, not all workloads are a good fit for public cloud. Our team can help validate the public cloud is the right placement option for your solution.  Please describe how your use case meets one (or more) of the criteria found in the [Helpful Links](https://cloud.optum.com/docs/intake/intake-links) .  Addressing more than one use case is advantageous.  
----------------------------------------
- [ ] I would like to engage with the Vanguard team to determine if Public Cloud is the best choice for our Application.

>-  Volatile or Elastic Capacity
>- Isolated workload - 
The data input for this application is from another database systems for e.g. EDW, NextGen, TruCare, IKA, Optum, the Risk Adjustment Team and local markets   which are in WellMed network. An ETL process of this application connects to source and loads the data to this application database.


----------------------------------------

## Section 2: Data Governance
> **PLEASE NOTE:**
> * The application specific Data Governance details requested below are for documentation purposes.
> * An approval of this public cloud account request is NOT an approval for use and movement of the data.
> * For specific questions regarding data usage and governance, the Data Governance team may be contacted at: data-governance@optum.com

### Data Details

> **Guidance**: Use this section to describe details about the data you will be hosting/collecting.  Remember to include details about the classification of the data.

#### Intended Data Use
> **Guidance**:  is this an existing or new Use case for the data?
>  * **Note:** there may be follow-up with additional questions by the Platform Data Governance team.
----------------------------------------

 - [ ] This is a new application
 - [X] This is a replacement for an existing system

Intended Data Use
*	Data Use Cases:
    - [X] Data use cases remain as-is and unchanged
    - [ ] New and/or modified use cases for the data

*	Does data need to return to targets outside of your cloud account?
    - [X] Yes
    - [ ] No

*	How will the data get back to those targets?

----------------------------------------

[Describe the data return methods here] An ETL process will be used to export the data back to shared folders, which are a part of WellMed network.



----------------------------------------


#### Upstream Data Interfaces and Sources

> **Guidance**: Describe your upstream data interfaces and sources.  Where does the data come from?
>
> What systems are they?
> - ASKID, ASK Short Name
>   Leverage the ASK Portal to research information about your data sources
> - If the downstream target is an external vendor or entity, please indicate that as well
>
> Other data notes to add (non-exhaustive):
> - In what domain does it reside (internal/external/other)?
> - How will you be accessing data from these systems from the cloud?
> - What size/quantity of data is ingested (GB/Day, GB in total)

----------------------------------------
- [ ] My application does not have any Upstream data interfaces or sources

| ASK ID           | ASK ID Short Name   | Other Data Notes   |
|------------------|:-------------------:|:-------------------|
| UHGWM110-013741  |           EDW          |                    |
| UHGWM110-023409  |      NextGen               |                    |
| UHGWM110-008884  |       TruCare              |                    |
| UHGWM110-008300  |         IKA            |                    |
| WellMed system with no ASK ID   |       Optum              |                    |
| WellMed system with no ASK ID  |         Risk Adjustment Team            |                    |

> Data will be imported on weekly or adhoc/on-demand basis.
----------------------------------------

#### Source Data Sets
> **Guidance**: Please supply details of the various data sets from the above sources that you are consuming, and provide a description of the information in those data sets
>   * Data Set Name (Examples: Member, Claim)
>   * Data Set Short description (Examples: standardized Member data, standardized Claim data)
>
> Example: dNHI contains User Views for consumption.
>
> Those include (but are not limited to):
> *	STATEVIEW: State level geographic view, for which use is permitted for the purposes of public health, healthcare operations, research, and product development.
> *	CCISTATEVIEW: A view combining clinical and administrative claimsdata. This view is a state level geographic view. CCISTATEVIEW is a copy of STATEVIEW plus clinical data.

----------------------------------------

[List source data sets you will be consuming]

- [ ] My application does not consume any Data Sets

| Data Set Name     | Data Set Description  |
|:-----------------:|:---------------------:|
|     Member and contact details              |     Member details like GMPI id and their contact information like phone, email and address details of the members                  |


----------------------------------------


#### Downstream Targets

> **Guidance**: Describe where your data will end up.
> - ASKID & Short name for the destination where the data is going
> - If the downstream target is an external vendor or entity, please indicate that as well
>
> Other data notes to add (non-exhaustive):
> - How will you be providing data to these systems from your cloud application?
> - What size/quantity of data is egressed/consumed (GB/Day, GB in total)

#
----------------------------------------

- [ ] My application does not have any Downstream Targets

----------------------------------------
> An ETL process will be used to export the data back to shared folders, which are a part of WellMed network.
#

## Section 3: Code Delivery and Management
Code delivery and management is the responsibility of application team. However, commercial cloud governance is predicated on infrastructure as code and platforms that accelerate adoption as the enterprise compliant path. It is required that all cloud applications fully implement IaC and automated CI/CD pipelines. Applications that do not will be flagged as out of compliance on Cloud Board.

> - **Overall Guidance**
>   - **NOTE:** verify that the members of the MS/hcc_intake SECURE group have access to these repos
>   - _**BETTER YET**_ - **make your repo Public** and share your expertise with the Optum community!

### Infrastructure as Code
> **Guidance:** Infrastructure as Code (IaC) allows you to build your infrastructure in an automated fashion.  This reduces your ongoing Operations Costs, and provides a simple, repeatable and secure way to build your Cloud Infrastructure, as well as supporting Disaster Recovery Operations.
> 
> - **ARM Templates are not an appropriate way to manage Infrastructure as Code as it does not manage state, or provide measurement of status which is a part of the HCC strategy.**
> 
> - **NonProd requests:**  Please identify the IaC method (most often Terraform) that will be leveraged
> - **Prod requests:** provide the actual links to the IaC/Terraform code that builds the cloud components.
----------------------------------------
- [ ] My team would like to engage with the Vanguard team to discuss the use of Infrastructure as Code and best practices

My team will be using Terraform to build our Infrastructure as Code

[For **Production** accounts, use this space to provide the direct links to your IaC GitHub repos]


----------------------------------------

### CI/CD

> **Guidance**: Continuous Integration/Continuous Deployment (CI/CD) are signs of a mature Engineering Practice.  CI/CD ensures that you are deploying the most up to date, validated code into your environment, as well as automatically generating your testing environment to have a better test cycle, and employ automated testing.  Jenkins is the preferred CI/CD tool at Optum.
>
> **NonProd requests:** Please identify the CI/CD service you are planning to use
>
> **Prod requests:** provide the actual links to successful fully automated builds of your IaC in a CI/CD pipeline
> * this is often a link or links into your Jenkins instance(s)
> * **NOTE:** verify that the members of the MS/hcc_intake SECURE group have access to see the results
----------------------------------------
- [ ] My team would like to engage with the Vanguard team to discuss the use of CI/CD best practices

My team will be using Optum server version of the Azure DevOps (https://azuredevops.optum.com/) pipelines for our CI/CD process.

[For **Production** accounts, use this space to provide direct links to describe your CI/CD build pipelines.]


----------------------------------------
#
## Section 4: Architecture Summary

### A note about Approved Cloud Components and Tech Landscape / PADU

----------------------------------------

Please note that you will need to validate that all components that you choose to implement are in Optum's [Tech Landscape (PADU)](https://techlandscape.optum.com/) with the following Ratings:
* NonProduction:  Must be rated as Preferred (P), Acceptable (A) or Emerging (E)
* Production. Must be rated as Preferred (P) or Acceptable (A)
* Using Discouraged or Unacceptable components may result in having to re-submit your request, and will delay your Intake review.  
 
For assistance in identifying alternatives, please [Connect with a Vanguard Specialist](https://hccvanguard.ideas.aha.io/ideas/new)!

### Architecture Overview

----------------------------------------

> **Guidance**: This section must contain logical architecture diagram(s) of your solution that can be reviewed by others.  The diagram should list all components in your account, should be clear which resources are in your account, in another account, or On Prem, and should indicate the type of cloud resource used to deploy each component.
> * Provide the actual diagram or diagrams in png or jpg format - not PDF files, please.
> * This should not be links to separate documents, nor documentation with embedded diagrams.

> * Strongly recommmend referencing this [link](https://vanguard.optum.com/docs/ArchitectureModels/architecture_template_overview) for Section 4 Architecture Summary diagram information and specifics.

> * Populate the table below (add rows as needed) to identify the cloud components and their purpose/usage.  Please add as much detail as possible to help the reviewers get a complete picture of your logical architecture.

```
You can link to an image by using this syntax:
    Local File Example:  ![Picture_Link_Title](picture_1.png)
    Remote File Example:  ![Picture_Link_Title](https://server.domain.com/directory/picture_1.png)
```


----------------------------------------

![OneSource Database Application Architecture](https://github.optum.com/Org-Wellmed/caresaci-cloud/blob/main/Cares%20ACI%20Architecture-V2.png)


| **S. No.** | **Component** | **Usage** | **PADU**   |
|-----------------| --------------- | --------------- | --------------- |
| **1** | Azure App Service     |     hosting application front end solution and API solution            |Acceptable|
| **2** | Azure Front Door    |       Global load balacing within regions , DDos, WAF, custom domain         |Not Found|
| **3** | Azure sql database     |      Database           |Acceptable|
| **4** | Azure data factory     |      For secure transfer of data from on-prem to Azure.           | Acceptable |
| **5** | virtual network, Subnet and NSG's    |      communication of Azure resources with the internet, communication between Azure resources, communication with on-premises resources, filtering network traffic, routing network traffic, and integration with Azure services           |Not Found|
| **6** | Azure KeyVault     |     For storing secrets         |Not Found|
| **7** | Azure Security Center |monitoring the security configuration and health of  workloads |Not Found|
| **8** | Azure DevOps (Optum Hosted) | CI/CD pipeline | Accepted |
| **9** | Azure Private Endpoint | Azure Private Endpoint is a network interface that connects you privately and securely to a service powered by Azure Private Link. This is used to connect the keyvault with resources in the virtual network |Not Found|
| **10** | Self Hosted Integration Runtime | A self-hosted integration runtime that can run copy activities between a cloud data store and a data store in a private network. This will be used for moving data from On-Prem into Azure Data Factory for this application |Not Found|
| **11** | Azure Monitor | Collects and organizes log and performance data from monitored resources to help maximize the availability and performance of your applications and services. |Not Found|
| **12** | Azure Resource Group | A resource group is a container that holds related resources for an Azure solution | Not Found |
----------------------------------------

- [ ] I would like to engage with the Vanguard team to for more detailed guidance on our Architecture in the Public Cloud.




----------------------------------------
#
## Section 5: Network Summary

### Network Summary Diagram

----------------------------------------

> **Guidance**: This section should contain logical network diagram(s) of your solution that can be reviewed by others. Provide the actual diagrams, not links to remote diagrams, nor documentation with embedded diagrams

>	For your new cloud subscription/account/project:
>	* Represent all components that are being built and consumed
>   * Clearly identify/seperate On-Prem, Public Cloud, and External Components into their own zones and label them
>	* **Clearly differentiate** what you are building from other cloud or on-prem components with which you are connecting, but are not building

> * Strongly recommmend referencing this [link](https://vanguard.optum.com/docs/ArchitectureModels/architecture_template_overview) for detailed Section 5 Network Summary diagram information and specifics

>   * Populate the General Flow Detail below the diagram by referencing the example template details.  Be sure to include Network Flow, Ports and Protocols and Numbered Callouts.  Please add as much detail as possible to help the reviewers get a complete picture of your network architecture





----------------------------------------

![OneSource Database Application Architecture](https://github.optum.com/Org-Wellmed/caresaci-cloud/blob/main/Cares%20ACI%20Architecture-NetworkSummary.png)


### General Flow Detail
See Sample Flow [here](https://vanguard.optum.com/docs/ArchitectureModels/solution_network_diagram#general-flow-detail-example)

1.  Application users will authenticate to the application using OneHealthcare ID for accessing the application via Azure Front door using HTTPS 443.
2. Members contact data from on-prem will be fed into Azure Data Factory using Azure Self-Hosted Integration Runtime (SHIR) using TLS 443.
3. All data retreival operations with SQL server will be happening over port 1433.
4. Front end application will be authenticating itself to the back end application using token based authentication using TLS 443.



- [ ] I would like to engage with the Vanguard team to for more detailed guidance on our Network in the Public Cloud.



------------------------------------------------------------
#
## Section 6: Security Criteria

### Security Considerations

> **Guidance**: Review any exceptions you may be seeking and why you need them.
>
> Some things to think about (non-exhaustive):
- Are there any resources that can't be created with automation?
- Are you needing to make use of non-standard ports (anything other than TCP 443)?
- Do you have extremely high volumes of data to move (over 10TB at a time)?

### EIS Security Intent Review

Application teams must meet all cloud security requirements including but not limited to the **55 Technical Controls and 14 Principles** as you will need to meet these controls within your solution when seeking the EIS Endorsement.  You do not need to include answers to these in the Intake Markdown document.

Per corporate policy 11A.4.01, you are required to perform a Risk Assessment Prior to Designing or Purchasing System

----------------------------------------
#
## Section 7: Circumstances and exceptions

> **Guidance**:  Please include any Circumstances or exceptions which require deviation from Policies or procedures.  A few examples are included for your use in documenting circumstances and exceptions.
> - [ ] Please remember that all Exceptions require appropriate approval as described in the [Exceptions Process](https://cloud.optum.com/docs/intake/intake-exception-process)
> - [ ] Please make sure to describe the exception and the high level reason for deviation

> **EXAMPLE**
>
> | Section | ID | Type     | Exception/Circumstance.   | Reason                                                               | Approval   |
> |---------|:--:|:--------:|:-------------------------:|:--------------------------------------------------------------------:|:----------:|
> | SEC 3.  | 1  | CIR.     | Cannot deploy DB with IaC | Incompatible installer                                               | B. Smith   | 
> | SEC 3.  | 2  | EX.      | FluShot not in PADU       | Unable to get into PADU for launch, plan on remediation by 1/1/2022  | A. Manager | 


***Please enter your Circumstances and Exceptions into the following table***

| Section | ID | Type     | Exception/Circumstance | Reason  | Approval              |
|---------|:--:|:--------:|:----------------------:|:-------:|:---------------------:|
| SEC X.  | X  | [CIR/EX] | XXXXX                  | XXXXXX  | XXXXX                 | 
| SEC X.  | X  | [CIR/EX] | XXXXX                  | XXXXXX  | XXXXX                 |   
| SEC X.  | X  | [CIR/EX] | XXXXX                  | XXXXXX  | XXXXX                 |   
| SEC X.  | X  | [CIR/EX] | XXXXX                  | XXXXXX  | XXXXX                 |   

**Please paste a Screen shot of all approved Exceptions**

--
#
**Internal Use Only:**  v6.2.0
<!-- bd602303 -->
