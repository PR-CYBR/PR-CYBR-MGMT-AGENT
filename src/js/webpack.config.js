// webpack.config.js
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: 'production', // Set to 'production' for optimized builds
  entry: path.resolve(__dirname, 'src/js/main.js'), // Entry point
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'dist/'), // Output directory
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
      template: path.resolve(__dirname, 'src/templates/index.html'), // Updated template path
      filename: 'index.html', // Output HTML file
    }),
  ],
  devServer: {
    static: {
      directory: path.resolve(__dirname, 'dist/'), // Updated for Webpack 5
    },
    compress: true,
    port: 9000,
  },
};