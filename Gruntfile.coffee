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
      src:
        expand: true
        cwd: 'lib/'
        src: ['**/*.coffee']
        dest: 'dist/lib/'
        ext: '.js'
      test:
        expand: true
        cwd: 'test/'
        src: ['**/*.coffee']
        dest: 'dist/test/'
        ext: '.js'

    mochaTest:
      test:
        options:
          # require: 'coffee-script/register'
          reporter: 'spec'
        src: [
          'dist/test/**/*.js'
        ]

    copy:
      dist:
        files: [
          expand: true,
          cwd: 'test',
          dest: 'dist/test/',
          src: [
            '**/*.json',
            '**/*.xml',
          ]
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

    release:
      options:
        beforeBump: ['test']


  # tasks.
  grunt.registerTask 'compile', [
    'clean'
    'coffee'
    'copy'
  ]

  grunt.registerTask 'test', [
    'coffeelint'
    'mochaTest'
  ]

  grunt.registerTask 'default', [
    'compile'
    'test'
  ]

