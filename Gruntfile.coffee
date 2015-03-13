'use strict'

module.exports = (grunt)->

  # load all grunt tasks
  require('load-grunt-tasks')(grunt)

  _ = grunt.util._
  path = require 'path'

  # Project configuration.
  grunt.initConfig

    pkg: grunt.file.readJSON('package.json')

    coffeelint:
      gruntfile:
        src: '<%= watch.gruntfile.files %>'
      lib:
        src: '<%= watch.lib.files %>'
      test:
        src: '<%= watch.test.files %>'
      options:
        configFile: 'coffeelint.json'

    coffee:
      lib:
        expand: true
        cwd: 'src/'
        src: ['**/*.coffee']
        dest: 'dist/'
        ext: '.js'
      # test:
      #   expand: true
      #   cwd: 'src/test/'
      #   src: ['**/*.coffee']
      #   dest: 'dist/test/'
      #   ext: '.js'

    mochaTest:
      test:
        options:
          require: 'coffee-script/register'
          reporter: 'spec'
        src: [
          'test/**/*.coffee'
        ]

    watch:
      options:
        spawn: false
      gruntfile:
        files: 'Gruntfile.coffee'
        tasks: ['coffeelint:gruntfile']
      lib:
        files: ['src/**/*.coffee']
        tasks: ['coffeelint:lib', 'coffee:lib', 'mochaTest']
      test:
        files: ['test/**/*.coffee']
        tasks: ['coffeelint:test', 'mochaTest']

    clean: ['dist/']

  grunt.event.on 'watch', (action, files, target)->
    grunt.log.writeln "#{target}: #{files} has #{action}"

    # coffeelint
    grunt.config ['coffeelint', target], src: files

    # coffee
    coffeeData = grunt.config ['coffee', target]
    files = [files] if _.isString files
    files = files.map (file)-> path.relative coffeeData.cwd, file
    coffeeData.src = files

    grunt.config ['coffee', target], coffeeData

  # tasks.
  grunt.registerTask 'compile', [
    'coffeelint'
    'coffee'
  ]

  grunt.registerTask 'test', [
    'mochaTest'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]

