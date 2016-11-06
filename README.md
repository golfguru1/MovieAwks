
#MovieAwks
<img src="https://cloud.githubusercontent.com/assets/3711400/16571008/007804d4-4220-11e6-87dd-480dd2dbdda6.png" width="20%"></img>
(In the process of redesigning new logo to match new UI.)

MovieAwks is an app that allows users to see how awkward a movie will be to watch with their family/parents. Awkward-ness is rated on a scale of 😇 to 💀 (see below for rating conversion)

I used Firebase as a backend to store all the ratings that users make, and this lovely API: [The Movie DB API](http://docs.themoviedb.apiary.io) which provides both movie info and posters.

###Rating
When rating the awkwardness of a movie, you must chose between 1-10 on the awkward scale:

* 0-1 : not at all awkward 😇
* 2-3 : meh awkward 😐
* 4-5 : getting pretty awkward 😔
* 6-7 : starting to get really uncomfortable 😬
* 8-9 : dangerous territory 😵
* 10 : 💀 (skull is self-explanitory)

##Current UI
<img src="https://cloud.githubusercontent.com/assets/3711400/20040540/cdfd2fc4-a427-11e6-9e47-6ed17659de99.png" width="19%"></img> 
<img src="https://cloud.githubusercontent.com/assets/3711400/20040541/cdfe4db4-a427-11e6-9e36-6d6b847c6383.png" width="19%"></img> 
<img src="https://cloud.githubusercontent.com/assets/3711400/20040543/ce022e0c-a427-11e6-8b91-d180a84bde7f.png" width="19%"></img>
<img src="https://cloud.githubusercontent.com/assets/3711400/20040539/cdfd1fac-a427-11e6-9ec9-5805ac780267.png" width="19%"></img>
<img src="https://cloud.githubusercontent.com/assets/3711400/20040542/ce015432-a427-11e6-99ee-19d549d8b365.png" width="19%"></img>
##//TODO
* Design Logo
* App Icon
* Launch Image
* ~~Add "no internet" warnings~~
* ~~**NEW NAME!**~~ *the name is growing on me, keeping it for now*
* ~~Re-do UI for Login/Sign up~~ DONE
* ~~Choose color scheme~~
* ~~Choose Font~~

###My Podfile

``` 
pod 'CRToast', '~> 0.0.7'
pod 'ASValueTrackingSlider'
pod 'SDWebImage', '~>3.7'
pod 'Firebase/Database'
pod 'MMDrawerController', '~> 0.4.0'
pod 'MMDrawerController+Storyboard'
pod 'Fabric'
pod 'Crashlytics'
pod 'Alamofire', '~> 4.0'
pod 'IQKeyboardManager'
pod 'Firebase'
pod 'Firebase/Auth'
```

##License
BSD License. PLZ don't steal it and call it your own! But feel free to make changes to make it better!

##Contact
Hit me up on twitter: [@softieeng](https://twitter.com/softieeng)