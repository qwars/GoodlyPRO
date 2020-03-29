const CopyWebpackPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin');
const {BaseHrefWebpackPlugin} = require('base-href-webpack-plugin');
const UglifyJS = require("uglify-js");
const command  = require('child_process');
const frontend = {
    context: __dirname + '/develop/client',
    devServer: {
        before: function(app){
            let subprocess = command.spawn('imbac',['--es5', '-pw','develop/server']);
            subprocess.server = command.exec(
                `node -e 'console.log("Start server")'`,
                (error, stdout, stderr) => console.log( '[\x1b[1m\x1b[36mSERVER\x1b[0m]', `: ${ stdout.trim() } : \x1b[35m${ subprocess.server.pid }\x1b[0m` )
            );
            subprocess.stdout.on('data',( data ) => {
                subprocess.killPID = subprocess.server.codePID && command.execSync( `kill -9 ${ subprocess.server.codePID }` );
                subprocess.server.kill();
                subprocess.codeData = UglifyJS.minify( `${ data }` ).code;
                subprocess.server = command.exec(`node -e '( function(){ ${ subprocess.codeData } })( console.log("Start server PID: ", process.pid ) )'`);
                subprocess.server.stdout.on('data', (data) => {
                    if ( typeof subprocess.killPID !== 'string' && data.toString().includes('Start server PID') ) {
                        let message = subprocess.killPID === undefined ? 'START' : 'RESTART'
                        subprocess.server.codePID = data.toString().match(/PID\D+(\d+)/)[1].trim();
                        console.log(
                            `[\x1b[1m\x1b[36mSERVER ${message}\x1b[0m]:`,
                            `\x1b[35m${subprocess.server.codePID}\x1b[0m`
                        );
                    }
                    else {
                        console.log( '[\x1b[1m\x1b[36mSERVER STDOUT\x1b[0m]:', `${ data }` );
                    }
                })
                subprocess.server.stderr.on('data', (data) => subprocess.server.codePID = console.log(
                    '[\x1b[1m\x1b[5m\x1b[31mSERVER STDERR\x1b[0m]',
                    `: ${ data.toString().includes('TypeError') ? data.toString().match(/TypeError:.+/)[0] : data }`) );
            });
            subprocess.stderr.on('data', (data) => console.error(`stderr: ${data}`) );
            ['SIGINT', 'SIGTERM','exit'].forEach( ( sig ) => process.on( sig, (code, signal) =>  subprocess.server.kill() && subprocess.kill() ) );
        },
        contentBase: ".public/",
        port: 9090,
        historyApiFallback: {
            rewrites: [
                { from: /.*/, to: '/index.html' }
            ]
        }
    },
    plugins: [
        new HtmlWebpackPlugin({ title: 'GoodlyPRO', base: '/' }),
        new BaseHrefWebpackPlugin({baseHref: '/' }),
        new MiniCssExtractPlugin(),
        new OptimizeCssAssetsPlugin({
            assetNameRegExp: /\.css$/g,
            cssProcessorPluginOptions: {
                preset: ['default', { discardComments: { removeAll: true } }],
            },
            canPrint: true            
        }),
	new CopyWebpackPlugin([
	    {
		cache: true,
		from: './favicon.ico',
		to: './favicon.ico'
	    }
	],{ copyUnmodified: true })
    ],    
    module: {
	rules: [
            {
                test: /images.+\.(jpe?g|png|gif|svg|ico)$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        useRelativePath: true,
                        outputPath: 'images',
                        publicPath: 'images'
                    }
                }]
            },
            {
                test: /fonts.+\.(woff(2)?|ttf|eot|svg)([?#]+\w+)?$/,
                use: [{
                    loader: 'file-loader',
                    options: {
                        name: '[name].[ext]',
                        useRelativePath: true,
                        outputPath: '/fonts',
                        publicPath: '/fonts'
                    }
                }]
            },            
            {
                test: /\.styl$/i,
                use: [
                    { loader: MiniCssExtractPlugin.loader },
                    { loader: 'css-loader'},
                    {
                        loader: 'postcss-loader',
                        options: {
	        	    plugins: [
                                require('autoprefixer'),
                                require('cssnano')({preset: ['default']})
                            ],
	        	    sourceMap: true
	        	}
                    },                    
                    { loader: 'stylus-loader' }
                ]
            },
            {
	        test: /\.css$/,
                use: [                    
                    { loader: MiniCssExtractPlugin.loader },
                    { loader: 'css-loader' },
                    {
                        loader: 'postcss-loader',
                        options: {
	        	    plugins: [
                                require('autoprefixer')
                            ],
	        	    sourceMap: true
	        	}
                    }
                ]
	    },
	    {
		test: /\.imba$/,
		loader: 'imba/loader',
	    }
	]
    },
    resolve: {
	extensions: [".imba", ".js", ".json"]
    },
    entry: "./index.imba",
    output: {
        path: __dirname + "/public/client/",
        filename: "application.js"
    }
};

module.exports = (env,arg) => [ frontend ]
