tecfiler
========

Utility to generate campaign finance filings for candidates/office-holders and specific
purpose committees.

This project is in development.

For design information, please see the wiki: https://github.com/chip-rosenthal/tecfiler/wiki

Background
----------

The requirements for candidate and lobbyist disclosures are set by the Texas Ethics Commission (TEC) [http://www.ethics.state.tx.us/main/local.htm].

Local candidate and lobbyist disclosures are filed not with the State, but with the Austin City Clerk.

Clerk takes filings on paper (or PDF versions of the forms).

The filings are posted online but are not easily searchable [http://www.austintexas.gov/department/campaign-finance-reports].

In April, the City Council passed an ordinance [http://www.austintexas.gov/edims/document.cfm?id=169484] to create an online, searchable database of campaign and lobbyist filings.

Initial staff estimates to implement have come back with: about 800K cost, about a year development, solution based on proprietary technology

In a meeting organized by Councilmember Morrison, city staff was open to the idea of a "civic sourced" effort to help reduce costs and time.

Some complexities not addressed:

* There are additional forms, such as the treasurer filing and correction filings, that are not scoped at this time.

* There are additional schedules that the City of Austin uses, that are not scoped in this discussion.

* Local government can require electronic filings, but the process is going to need TEC approval.


TEC Forms
---------

**Form C/OH**: Candidate/Office-Holder Campaign Finance Report
http://www.ethics.state.tx.us/forms/coh.pdf

* Schedule A: Political Contributions other than Pledges or Loans
* Schedule B: Pledged Contributions
* Schedule E: Loans
* Schedule F: Political Expenditures
* Schedule G: Political Expenditures Made from Personal Funds
* Schedule H: Payment from Political Contributions to a Business of C/OH
* Schedule I: Non-Political Expenditures made from Political Contributions
* Schedule K: Interest Earned, Other Credits/Gains/Refunds, and Purchase of Investments
* Schedule T: In-Kind Contribution or Political Expenditure for Travel Outside of Texas

**Form SPAC**: Specific-Purpose Committee Campaign Finance Report
http://www.ethics.state.tx.us/forms/spac.pdf

* Schedule A: Political Contributions other than Pledges or Loans
* Schedule B: Pledged Contributions
* Schedule C: Corporate or Labor Organization Contributions other than Pledges or Loans
* Schedule D: Pledged Corporate or Labor Contributions
* Schedule E: Loans
* Schedule F: Political Expenditures
* Schedule H: Payment from Political Contributions to a Busines of C/OH
* Schedule I: Non-Political Expenditures made from Political Contributions
* Schedule J: Political Contributions Returned to Committee
* Schedule K: Interest Earned, Other Credits/Gains/Refunds, and Purchase of Investments
* Schedule T: In-Kind Contribution or Political Expenditure for Travel Outside of Texas

**TEC Automation and Import Format**

The state provides free software for electronic filing with the state. The software can
be used to generate reports for local filing, but does not support electronic filing locally.

The state software allows import of contributions and expenditures. Our tool will be
modeled around this import format. It is documented in the TX-CFA Import Guide:

http://www.ethics.state.tx.us/whatsnew/ImportGuide.pdf

