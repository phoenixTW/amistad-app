gulp = require('gulp')
rename = require('gulp-rename')
autoprefixer = require('gulp-autoprefixer')
concat = require('gulp-concat')
uglify = require('gulp-uglify')
imagemin = require('gulp-imagemin')
cache = require('gulp-cache')
sass = require('gulp-sass')
clean = require('gulp-clean')
connect = require('gulp-connect-multi')()

errorLog = (error) ->
  console.log.bind(error)
  this.emit('end')

gulp.task "connect-service-manager", connect.server(
  root: ["./"]
  port: 8000
  livereload: true
  open:
    browser: "Google Chrome" # if not working OS X browser: 'Google Chrome'
)

gulp.task 'clean', ->
  gulp.src('dist/', read: false)
  .pipe clean()
  .pipe connect.reload()

gulp.task 'reload-server', ->
  connect.reload()

gulp.task 'images', ->
  gulp.src('src/images/**/*').pipe(cache(imagemin(
    optimizationLevel: 3
    progressive: true
    interlaced: true)))
  .pipe gulp.dest('dist/images/')

gulp.task 'styles', ->
  gulp.src([ 'src/styles/**/*.scss' ]).on('error', errorLog)
  .pipe(sass({
      style: 'compressed'
    }))
  .pipe(autoprefixer('last 2 versions'))
  .pipe(gulp.dest('dist/styles/'))
  .pipe connect.reload()

gulp.task 'scripts', ->
  gulp.src('public/javascripts/**/*.js').on('error', errorLog)
  .pipe(concat('main.js'))
  .pipe(gulp.dest('dist/scripts/'))
  .pipe(rename(suffix: '.min'))
  .pipe(uglify())
  .pipe(gulp.dest('dist/scripts/'))
  .pipe connect.reload()

gulp.task 'default', [ 'clean', 'connect-service-manager', 'styles', 'scripts']
