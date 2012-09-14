// Generated by CoffeeScript 1.3.3
(function() {
  var Highlight, highlightNewMessages;

  window.bayes = new classifier.Bayesian();

  if (this['classifier_info']) {
    bayes.fromJSON(classifier_info);
  }

  Highlight = (function() {

    function Highlight() {}

    Highlight.prototype.highlighted_text = function() {
      var text;
      text = $('<div/>').html(this.data('original_html').replace(/<br>/g, 'REPLACEMENT_LINEBREAK')).text();
      text = hljs.highlightAuto(text).value.replace(/REPLACEMENT_LINEBREAK/g, '<br>');
      return "<pre style='overflow-x: auto;'><code>" + text + "</code></pre>";
    };

    Highlight.prototype.baysian_data = function() {
      return this.text().split(' ');
    };

    Highlight.prototype.setCategory = function(category) {
      if (category === 'text') {
        this.html(this.data('original_html'));
      } else if (category === 'code') {
        this.html(this.highlighted_text());
      }
      this.add_hud();
      return bayes.train(this.baysian_data(), category);
    };

    Highlight.prototype.guess = function() {
      return this.setCategory(bayes.classify(this.text()));
    };

    Highlight.prototype.add_hud = function() {
      var _this = this;
      this.append("<div class='GTalkSyntax-HUD'><span class='GTalkSyntax-text'>text</span> | <span class='GTalkSyntax-code'>code</span></div>");
      this.find(".GTalkSyntax-code").click(function() {
        return _this.setCategory('code');
      });
      return this.find(".GTalkSyntax-text").click(function() {
        return _this.setCategory('text');
      });
    };

    return Highlight;

  })();

  $.fn.highlight = function() {
    return this.each(function(index, element) {
      var key, value, _ref;
      element = $(element);
      _ref = Highlight.prototype;
      for (key in _ref) {
        value = _ref[key];
        element[key] = value;
      }
      return element.css({
        position: 'relative'
      }).data({
        original_html: element.html()
      }).guess();
    });
  };

  highlightNewMessages = function() {
    $('[role=log] .kl').filter(function() {
      return $(this).find('.GTalkSyntax-HUD').length < 1;
    }).highlight();
    return setTimeout(highlightNewMessages, 200);
  };

  setTimeout(highlightNewMessages, 1000);

  console.log('loaded highlight');

}).call(this);
