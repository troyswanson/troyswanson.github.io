var casper = require('casper').create();

casper.start('http://localhost:9292/', function() {
    this.echo(this.getTitle());
});

casper.run();
