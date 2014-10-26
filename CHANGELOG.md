prestashop CHANGELOG
====================

0.2.0
-----
- Inclusion of Presh as a command line tool

0.1.2
-----
- Fixes

0.1.1
-----
- Changed the default base directory where Prestashop will be installed
- Fix in the way the URL to download Prestashop from is set. There was a bug when the configured version is different from the default one, because Chef evaluates each
attribute too early, so the final URL value was wrong and as consequence the whole cookbook failed

0.1.0
-----
- Initial release of prestashop, a Chef cookbook to install and configure a web site based on Prestashop, an e-commerce Open Source solution
