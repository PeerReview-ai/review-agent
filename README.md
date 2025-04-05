# PeerReview GitHub Action

A GitHub Action that provides AI-powered code review capabilities through GitHub App integration.

## Usage

Add this to your repository's `.github/workflows/peerreview.yml`:

```yaml
name: PeerReview

on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  peer-review:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@v4
      - name: Run PeerReview
        uses: PeerReview-ai/review-agent@v1.0.0
        with:
          api-key: ${{ secrets.PEERREVIEW_API_KEY }}
          api-endpoint: https://api.getpeerreview.com
          review-type: full  # optional: full, focused, or security
```

## Setup

1. Install the GitHub App:
   - Go to [PeerReview GitHub App](https://github.com/apps/peerreviewapp)
   - Click "Configure" to install the app
   - Select the repositories where you want to enable AI code reviews
   - Click "Install"

2. Add the required secret to your repository:
   - Go to your repository's Settings → Secrets and variables → Actions
   - Add the following secret:
     - `PEERREVIEW_API_KEY`: Your PeerReview API key

## Features

- 🤖 AI-powered code reviews
- 🔍 Multiple review types:
  - `full`: Comprehensive review of code quality, security, and best practices
  - `focused`: Quick review focusing on critical issues
  - `security`: Security-focused review
- 📝 Inline code comments
- 🔄 Automatic review on PR open/update
- ⚡ Fast response times
- 🔒 Secure GitHub App integration

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `api-key` | API key for the PeerReview service | Yes | |
| `api-endpoint` | The endpoint URL of the PeerReview service | Yes | |
| `review-type` | Type of review to perform (full, focused, security) | No | full |
| `installation-id` | GitHub App installation ID (if known) | No | |

## Outputs

| Output | Description |
|--------|-------------|
| `review-completed` | Whether the review was completed successfully |
| `error` | Error message if the review failed |

## License

MIT 