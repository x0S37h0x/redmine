// plugins/x0s37h0x_Gamification/webpack.config.js
const path = require('path');

module.exports = {
  mode: 'development',
  entry: './app/javascript/packs/application.js',
  output: {
    path: path.resolve(__dirname, 'app/assets/javascripts'),
    filename: 'bundle.js',
  },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-env', '@babel/preset-react'],
          },
        },
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.jsx'],
  },
};
