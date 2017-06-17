
(function () {
    var app = angular.module('civichack17App', ['DataManager', 'ui.router', 'rzModule', 'angular-centered']);
    app.config(function ($stateProvider, $urlRouterProvider) {//, $locationProvider) {
        
        // $locationProvider.html5Mode(true);
        particlesJS.load('particles-js', 'particles-config.json', null);
        $urlRouterProvider.otherwise('/');
        $stateProvider
            .state('home', {
                url: '/',
                abstract: false,
                templateUrl: '/views/home.html',
                controller: 'homeCtrl',
                controllerAs: 'home'
            });

    });
    app.directive('particles', function($window) {
	return {
		restrict: 'A',
        replace: true,
        template: '<div class="particleJs" id="particleJs"></div>',
		link: function(scope, element, attrs, fn) {

            $window.particlesJS('particleJs', {
  "particles": {
    "number": {
      "value": 96,
      "density": {
        "enable": true,
        "value_area": 552.4295060491032
      }
    },
    "color": {
      "value": "#001889"
    },
    "shape": {
      "type": "circle",
      "stroke": {
        "width": 0,
        "color": "#000000"
      },
      "polygon": {
        "nb_sides": 5
      },
      "image": {
        "src": "img/github.svg",
        "width": 100,
        "height": 100
      }
    },
    "opacity": {
      "value": 0.5,
      "random": false,
      "anim": {
        "enable": false,
        "speed": 1,
        "opacity_min": 0.1,
        "sync": false
      }
    },
    "size": {
      "value": 3,
      "random": true,
      "anim": {
        "enable": false,
        "speed": 40,
        "size_min": 0.1,
        "sync": false
      }
    },
    "line_linked": {
      "enable": true,
      "distance": 157.83700172831522,
      "color": "#007506",
      "opacity": 0.5524295060491032,
      "width": 1
    },
    "move": {
      "enable": true,
      "speed": 8.011985930952699,
      "direction": "none",
      "random": true,
      "straight": false,
      "out_mode": "bounce",
      "bounce": false,
      "attract": {
        "enable": true,
        "rotateX": 600,
        "rotateY": 1200
      }
    }
  },
  "interactivity": {
    "detect_on": "canvas",
    "events": {
      "onhover": {
        "enable": true,
        "mode": "repulse"
      },
      "onclick": {
        "enable": true,
        "mode": "push"
      },
      "resize": true
    },
    "modes": {
      "grab": {
        "distance": 267.8027997565431,
        "line_linked": {
          "opacity": 1
        }
      },
      "bubble": {
        "distance": 400,
        "size": 40,
        "duration": 2,
        "opacity": 8,
        "speed": 3
      },
      "repulse": {
        "distance": 70,
        "duration": 0.4
      },
      "push": {
        "particles_nb": 4
      },
      "remove": {
        "particles_nb": 2
      }
    }
  },
  "retina_detect": false
});

		}
	};
});
    app.exports = app;
})();
