const { environment } = require('@rails/webpacker')
const webpack = require('webpack');

environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/src/jquery',
    jQuery: 'jquery/src/jquery',
    jquery: 'jquery',
    "window.jQuery": "jquery"
  })
);

module.exports = environment
