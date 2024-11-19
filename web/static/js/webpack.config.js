// web/static/js/webpack.config.js
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: 'production', // Set to 'production' for optimized builds
  entry: path.resolve(__dirname, '../static/js/main.js'), // Ensure this path is correct
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, '../dist'), // Ensure this path is correct
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
      template: path.resolve(__dirname, '../templates/status.html'), // Ensure this path is correct
      filename: 'status.html', // Output HTML file
    }),
  ],
  devServer: {
    static: {
      directory: path.resolve(__dirname, '../dist'), // Ensure this path is correct
    },
    compress: true,
    port: 9000,
  },
};