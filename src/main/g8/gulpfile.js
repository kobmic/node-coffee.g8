var gulp = require('gulp');
var less = require('gulp-less');
var path = require('path');
var minifyCSS = require('gulp-minify-css');
var del = require('del');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');
var rename = require('gulp-rename');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rev = require('gulp-rev');
var usemin = require('gulp-usemin');
var mocha = require('gulp-mocha');
var livereload = require('gulp-livereload');
var nodemon  = require('gulp-nodemon');

gulp.task('build', ['usemin', 'copy']);
gulp.task('default', ['build']);

gulp.task('clean', function(cb) {
    del(['static'], cb)
});

gulp.task('clean:coffee', function(cb) {
    del(['static/debug/scripts'], cb)
});

gulp.task('clean:css', function(cb) {
    del(['static/debug/css'], cb)
});

gulp.task('clean:stylesheets', function(cb) {
    del(['static/debug/stylesheets'], cb)
});

// copy tasks
// copy less, libs & images to static/release
// copy less, libs, images & html to static/debug
gulp.task('copy', ['copy:less', 'copy:vendor', 'copy:images', 'copy:html']);
gulp.task('copy:less', ['clean:stylesheets'], function(cb) {
    return gulp.src('./public/stylesheets/*.less')
        .pipe(gulp.dest('./static/debug/stylesheets'));
});

gulp.task('copy:vendor', function(cb) {
    return gulp.src('./public/vendor/**/*.*')
        .pipe(gulp.dest('./static/debug/vendor'));
});

gulp.task('copy:images', function(cb) {
    return gulp.src('./public/images/**/*.*')
        .pipe(gulp.dest('./static/debug/images'))
        .pipe(gulp.dest('./static/release/images'));;
});

gulp.task('copy:html', function(cb) {
    return gulp.src('./public/views/*.html')
        .pipe(gulp.dest('./static/debug/views'));
});


// Compile coffeescript
gulp.task('coffee', ['clean:coffee'], function() {
    return gulp.src('./public/scripts/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({ bare: true })).on('error', gutil.log)
        .pipe(sourcemaps.write('./maps'))
        .pipe(gulp.dest('./static/debug/scripts'));
});

// compile less
gulp.task('less', ['clean:css'], function () {
    return gulp.src('./public/stylesheets/*.less')
        .pipe(less({ paths: [ path.join(__dirname, 'public/stylesheets') ] }))
        .pipe(gulp.dest('./static/debug/css'));
});

// usemin
gulp.task('usemin', ['less', 'coffee'], function() {
    gulp.src('./public/views/*.html')
        .pipe(usemin({
            css: [less({ paths: [ path.join(__dirname, 'public/stylesheets') ] }), minifyCSS(), rev()],
            jslib: [uglify(), rev()],
            js: [uglify(), rev()]
        }))
        .pipe(gulp.dest('./static/release/views'));
});

// test
gulp.task('test', function () {
    require('coffee-script/register');
    return gulp.src('./test/**/*.coffee', {read: false})
        .pipe(mocha({reporter: 'spec', compilers: 'coffee:coffee-script'}));
});

// watch changes
gulp.task('watch', function () {
    gulp.watch('public/scripts/**/*.coffee', ['coffee']);
    gulp.watch('public/stylesheets/**/*.less', ['copy:less']);
});

// run server
gulp.task('run', ['watch'], function (cb) {
    nodemon({'script': 'server.js', ext: 'js html', env: { 'NODE_ENV': 'development' }});
});

