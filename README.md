
#MovieAwks
<img src="https://cloud.githubusercontent.com/assets/3711400/16571008/007804d4-4220-11e6-87dd-480dd2dbdda6.png" width="20%"></img> 

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
<img src="https://cloud.githubusercontent.com/assets/3711400/15725189/a4d733be-2818-11e6-9b2a-b1d1ba85acd7.png" width="23%"></img> <img src="https://cloud.githubusercontent.com/assets/3711400/15725188/a4d36540-2818-11e6-8e73-e5dde8d38c2c.png" width="23%"></img> <img src="https://cloud.githubusercontent.com/assets/3711400/15725187/a4d19602-2818-11e6-98de-c5ea87c7b06f.png" width="23%"></img> <img src="https://cloud.githubusercontent.com/assets/3711400/15725186/a4d0c75e-2818-11e6-8006-bf3f0978c41d.png" width="23%"></img> 

<img src="https://cloud.githubusercontent.com/assets/3711400/16131676/5d4d642a-33dd-11e6-82ce-3b8f2aeab01a.png" width="23%"></img> <img src="https://cloud.githubusercontent.com/assets/3711400/16131677/5d4f89b2-33dd-11e6-9026-efee5ee32669.png" width="23%"></img> <img src="https://cloud.githubusercontent.com/assets/3711400/16131675/5d4bb27e-33dd-11e6-9833-a76d90fa60c8.png" width="23%"></img> 

##//TODO
* ~~Add "no internet" warnings~~
* ~~Design Logo~~ *See Above*
* ~~App Icon~~
* ~~Launch Image~~
* ~~**NEW NAME!**~~ *the name is growing on me, keeping it for now*
* ~~Re-do UI for Login/Sign up~~ DONE
* ~~Choose color scheme~~ B&W and gray
* ~~Choose Font~~ *Futura looks good*

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
pod 'Alamofire', '~> 3.0'
pod 'IQKeyboardManager'
pod 'Firebase'
pod 'Firebase/Auth'
```

##License
BSD License. PLZ don't steal it and call it your own! But feel free to make changes to make it better!

##Contact
Hit me up on twitter: [@softieeng](https://twitter.com/softieeng)