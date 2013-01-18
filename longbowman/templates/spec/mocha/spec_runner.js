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
  window.expect = chai.expect;

  var tests = [
    'spec/dummy.test'
  ];

  mocha.setup({
    ui: 'bdd'
    , globals: ['XMLHttpRequest']
  });

  require(tests, function(){
    mocha.run();
  });

});
