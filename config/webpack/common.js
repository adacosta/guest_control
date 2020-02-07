const webpack = require('webpack');
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const MomentLocalesPlugin = require('moment-locales-webpack-plugin');

let config = {
  entry: {
    main: path.resolve(__dirname, 'entry.js')
  },
  output: {
    filename: '[name].bundle.js',
    path: path.resolve(__dirname, '../../public/dist'),
    publicPath: '/dist'
  },
  resolve: {
    alias: {
      amber: path.resolve(__dirname, '../../lib/amber/assets/js/amber.js')
    }
  },
  module: {
    rules: [
      {
        test: /\.(sass|scss|css)$/,
        exclude: /node_modules/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader'
        ]
      },
      {
        test: /\.(png|svg|jpg|gif)$/,
        exclude: /node_modules/,
        use: [
          'file-loader?name=/images/[name].[ext]'
        ]
      },
      {
        test: /\.(woff|woff2|eot|ttf|otf)$/,
        exclude: /node_modules/,
        use: [
          'file-loader?name=/[name].[ext]'
        ]
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env']
          }
        }
      },
      {
        test: require.resolve('jquery'),
        use: [{
          loader: 'expose-loader',
          options: 'jQuery'
        },{
          loader: 'expose-loader',
          options: '$'
        }]
      },
      {
        test: require.resolve('moment'),
        use: [{
          loader: 'expose-loader',
          options: 'moment'
        }]
      },
      {
        test: path.resolve(__dirname, '../../lib/amber/assets/js/amber.js'),
        use: [{
          loader: 'expose-loader',
          options: 'Amber'
        }]
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({
      filename: '[name].bundle.css'
    }),

    // Or: To strip all locales except “en”, “es-us” and “ru”
    // (“en” is built into Moment and can’t be removed)
    new MomentLocalesPlugin({
        localesToKeep: ['en'],
    }),
  ],
  // For more info about webpack logs see: https://webpack.js.org/configuration/stats/
  stats: 'errors-only'
};

module.exports = config;
