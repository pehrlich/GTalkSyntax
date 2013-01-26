# GTalkSyntax

A Google Chrome extension for enabling syntax highlighting in Google Talk.

Available in the [Chrome Web Store](https://chrome.google.com/webstore/detail/gtalksyntax/okpdnaeoefggpaccmolhoaiffmmdoool).

### Usage
Chat with someone.  Select "Text" or "Code" to use syntax highlighting.

Visit [chrome://chrome/extensions/]() and click GTalkSyntax options to enable data collection, at either the official or your own custom server.  This bit is still under construction.


### Design goals 
* Intelligent code detection, using Baysian classification to automatically highlight chat messages.
* Intelligent language detection (via highlight.js), to correctly highlight languages
* Backtick parsing for manual highlighting control
* (opt-in) live data collection, for better machine learning.  Powered by NodeJS. ([source](https://github.com/pehrlich/BaysianServer))


### Developer Installation
Clone repository.  In chrome, navigate to [chrome://chrome/extensions/]().  Select repository from "Load unpacked extension".

Server-side repository here:
[https://github.com/pehrlich/BaysianServer]()

### Maintainence
Contact [@ehrlicp](twitter.com/ehrlicp) on twitter.
