# Publishing EthnoQuant on GitHub and Zenodo

## A. Prepare locally

1. Extract this archive and inspect `EthnoQuant/app.R`, `EthnoQuant/www/`, and the included example files.
2. Install R dependencies (`shiny`, `readxl`, `vegan`) and run the application in RStudio. Run `source("tests/run_all.R")` and `source("tests/test_advanced_analytics.R")` from the `EthnoQuant` folder. Review all reported errors.
3. Confirm you own or have permission to redistribute the supplied logos, generated banner and any third-party assets.
4. **Choose a license before publication.** This package deliberately does not assert a license on your behalf. Add a LICENSE file (e.g., MIT, GPL-3.0-or-later) only after deciding. If not licensed, other people do not automatically receive rights to reuse your code.
5. Remove or anonymize any personal survey data; the included data are synthetic examples.

## B. GitHub repository

Create an empty GitHub repository named `EthnoQuant` (do not initialize with a README if uploading by Git). From the directory containing the `EthnoQuant` folder, run:

```bash
cd EthnoQuant
git init
git add .
git commit -m "Initial EthnoQuant research release candidate"
git branch -M main
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/EthnoQuant.git
git push -u origin main
```

Alternatively upload the contents of `EthnoQuant/` through GitHub's web interface (not the parent folder). Replace `YOUR_GITHUB_USERNAME` with your account name. Never upload credentials, participant identifiers, or confidential data.

## C. Zenodo DOI via GitHub integration

1. Log into Zenodo (https://zenodo.org/) and connect your GitHub account under its GitHub integration settings.
2. Enable the `EthnoQuant` repository for archiving in Zenodo.
3. On GitHub, create a release tag such as `v1.0.0-rc1` and publish a GitHub Release. Use a release candidate tag until testing and scientific validation are complete.
4. Wait for Zenodo to archive the GitHub release. Confirm the deposit metadata, author, license and DOI on Zenodo.
5. Update `CITATION.cff` and README with the **actual** Zenodo DOI, commit/tag and GitHub repository URL. Do not invent a DOI.
6. For a stable published release, publish a new validated GitHub release (e.g., `v1.0.0`) after completing all checks. Zenodo versions can have distinct version DOIs and a concept DOI.

You may instead upload a ZIP directly to Zenodo and create a software record manually, but avoid publishing duplicate records for the same release. Select resource type `Software`, specify creators/affiliation, version, release date, keywords, description, and chosen license.

## D. Suggested metadata

- Title: EthnoQuant: A Comprehensive Toolkit for Quantitative Ethnobotany Analysis
- Creator: Manish Mathur
- Affiliation: ICAR-Central Arid Zone Research Institute, Jodhpur, India
- Version: 1.0.0-rc1 (research release candidate)
- Keywords: ethnobotany, quantitative indices, R Shiny, PCA, CCA, clustering, statistical tests
- DOI: **add after Zenodo assigns one**
- Software license: **select before public release**

## E. Quality and scientific limitations

The 69-method catalog is a reference library, not evidence that all 69 calculators are executable or verified. PCA and inferential tests must respect observational units, independence, data structure, missingness and assumptions. Uploaded aggregated counts cannot be treated as individual informant records. Do not publish the application as a clinically validated decision tool.
