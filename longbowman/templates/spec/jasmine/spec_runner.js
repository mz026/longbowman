require.config({
  paths: {
    jquery: "vendor/jquery/jquery.min"
    , ember: "vendor/ember/ember"
    , handlebars: "vendor/handlebars/handlebars-1.0.0-rc.1"
    , text: "vendor/requirejs-text/text"
  }
  , shim: {
    ember: {
      deps: [ 'jquery', 'handlebars' ]
      , exports: 'Ember'
    }
  }
});

require([], function() {

  var tests = [
    'spec/dummy.test'
  ];

  require(tests, function(){
    var jasmineEnv = jasmine.getEnv()
    jasmineEnv.addReporter(new jasmine.HtmlReporter);
    jasmineEnv.execute();
  });

});
