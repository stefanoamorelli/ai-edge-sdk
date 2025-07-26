## Tallinn Secure Software Practices for OSS

_A security baseline from the OWASP Tallinn Chapter_

This project follows the **Tallinn Secure Software Practices for OSS**, developed to help open source maintainers and contributors build and maintain secure software. It provides a baseline of practical security practices informed by OWASP.

## Reporting Security Issues

If you discover a security vulnerability, please report it privately and responsibly.  
Do not create a public GitHub issue.

**Contact:**  
- Email: `stefano@amorelli.tech`  

We will acknowledge your report within *7 business days* and aim to resolve confirmed issues within 90 days or faster, depending on severity. Credit will be given unless anonymity is requested.

## Secure Development Practices

### Secrets and Credentials
- Never commit secrets (API keys, passwords, tokens) to the codebase.
- Use environment variables or secret managers (e.g., Vault, GitHub Actions secrets).
- Enable secret scanning and use pre-commit hooks to prevent accidental leaks.

### Dependencies and Supply Chain
- Pin dependencies and avoid using unmaintained packages.
- Use automated tools (e.g., Dependabot, OSV Scanner) to identify known vulnerabilities.
- Review and verify new dependencies before adding them.
- Consider generating an SBOM (Software Bill of Materials) for major releases.

### Code and Commit Hygiene
- All changes must go through pull requests with at least one code review.
- Protect the main branch (e.g., require PRs, reviews, passing CI).
- Encourage signed commits and signed release tags.
- Avoid force-pushes and direct commits to protected branches.

### CI/CD and Build Security
- Run builds in isolated, ephemeral environments.
- Use least-privilege CI tokens and restrict access to secrets.
- Review third-party CI/CD actions and pin versions or SHAs.
- Do not deploy unreviewed code to production environments.

## Vulnerability Handling Process

Once a vulnerability is confirmed:

1. It is triaged and, if valid, addressed privately.
2. A patch is prepared and tested.
3. A security advisory is drafted and coordinated with relevant stakeholders.
4. The patch is released, and the advisory is published.
5. Affected users are notified through appropriate channels.

## Security Considerations for AI Edge SDK

### Device-Specific Risks
- This plugin only works on Pixel 9 devices with AICore - reduces attack surface
- All AI processing happens on-device - no data transmission to external servers
- Plugin enforces strict device validation to prevent unauthorized usage

### Input Validation
- All prompts are validated before processing
- Plugin includes comprehensive error handling for malformed inputs
- Device compatibility is checked before any AI operations

### Data Privacy
- No user data is transmitted over networks
- All AI inference happens locally on the device
- Plugin follows Google's AICore privacy principles

## Responsible Disclosure

We encourage responsible disclosure of security vulnerabilities. Please:

1. Allow reasonable time for us to address the issue before public disclosure
2. Provide sufficient detail to reproduce the vulnerability
3. Avoid accessing or modifying data that doesn't belong to you
4. Act in good faith and avoid privacy violations or service disruption

Thank you for helping keep this project secure!