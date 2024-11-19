// web/static/js/webpack.config.js
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: 'production', // Set to 'production' for optimized builds
  entry: path.resolve(__dirname, 'status-page.js'), // Adjusted entry point path
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, '../dist'), // Adjusted output directory path
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env'],
          },
        },
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.resolve(__dirname, '../templates/status.html'), // Adjusted template path
      filename: 'index.html', // Output HTML file
    }),
  ],
  devServer: {
    contentBase: path.resolve(__dirname, '../dist'), // Adjusted content base path
    compress: true,
    port: 9000,
  },
};