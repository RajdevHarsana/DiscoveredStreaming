//
//  Config.swift
//  Receipt Catcher
//
//  Created by tarun-mac-6 on 04/03/19.
//  Copyright © 2019 Tarun Nagar. All rights reserved.
//

import UIKit

class Config: NSObject {
    let API_URL = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/users/"
    let API_ArtistUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/artists/"
    let API_TicketsUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/Tickets/"
    let API_PaymentUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/transaction/"
    let API_PackageUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/transaction/packagePlan/"
    let API_FeaturedUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/transaction/packagePlan/featured/"
   // let API_ArtistUrl = "http://i.devtechnosys.tech:8083/DiscoveredStreaming/artistsServe/"
    let debug_mode = 1
   let screenWidth = UIScreen.main.bounds.size.width
   let screenHeight = UIScreen.main.bounds.size.height

    // Users API
    let API_Login = "login"
    let API_Signup = "signup"
    let API_OtpVerification = "otpVerification"
    let API_FacebookLogin = "facebookLogin"
    let API_TwitterLogin = "twitterLogin"
    let API_ForgotPassword = "forgotPassword"
    let API_ResetPassword = "resetPassword"
    let API_ResendOtp = "resendOtp"
    let API_ProfileSetup = "editProfile"
    let API_UserDetail = "userDetails"
    let API_ChangePassword = "changepassword"
    let API_Updateprofile = "updateProfile"
    let API_ForgotOtp = "forgotOtpVerify"
    let API_ResendForgotOtp = "resendForgotOtp"
    
    //Artist API
    
    let API_CreateArtist = "create_artist"
    let API_GenresList = "get_genres_list"
    let API_ArtistListing = "get_artist_list"
    let API_ArtistDetail = "artist_detail"
    let API_ArtistFollowUnfollow = "followUnfollow"
    let API_ArtistLikeUnlike = "likeUnlike"
    let API_CreateBand = "create_band"
    let API_BandList = "band_list"
    let API_BandDetail = "band_detail"
    let API_CreatePost  = "create_post"
    let API_PostListing  = "post_list"
    let API_CreateEvent = "create_event"
    let API_EventListing = "event_list"
    let API_CancelEvent = "manage_event"
    let API_PostComment = "post_comment"
    let API_CommentList = "comment_list"
    let API_Search = "search"
    let API_ArtistBandListing = "artist_band_list"
    let API_BandInvitation = "band_invitation"
    let API_AcceptReject = "accept_reject_status"
    let API_CreateVenue = "create_venue"
    let API_VenueList = "venue_list"
    let API_VenueDetail = "venue_detail"
    let API_EventDetail = "event_detail"
    let API_RalatedPostList = "related_post_list"
    let API_GetUserRole = "get_user_role"
    let API_GetMemberList = "get_member_list"
    let API_UpdateArtist = "update_artist"
    let API_UpdateBand = "update_band"
    
    let API_UploadSong = "upload_song"
    let API_SongList = "song_list"
    let API_SongDetail = "song_detail"
    let API_UpdateSong = "updateSong"
    let API_DeleteData = "delete_data"
    let API_SongLikeUnlike = "songLikeUnlike"
    let API_FavouriteSong = "favourite"
    let API_SearchFilterSort = "filter"
    let API_GetBasicDetail = "getBasicDetail"
    let API_ArtistProfileBandList = "profileArtistBandList"
    let API_UpcomingPastEvent = "upcomingPastEvents"
    let API_EventInvites = "invitation"
    let API_GetFollowingList = "getFollowingList"
    let API_DeleteVenue = "delete_venue"
    let API_UpdatePost = "updatePost"
    let API_DeletePost = "deleteData"
    let API_PostDetail = "postDetail"
    let API_Myplaylist = "myPlaylist"
    let API_Createplaylist = "createPlaylist"
    let API_RemovePlaylistSong = "removeSongFromList"
    let API_Report = "commentReport"
    let API_AddSongPlayList = "addPlaylistSong"
    let API_SongDelete = "songDelete"
    
    let API_BookTickets = "bookTicket"
    let API_TicketDetail = "ticketDetail"
    let API_TicketList = "ticketList"
    let API_Dashboard = "dashboardData"
    let API_RewardList = "rewardsList"
    let API_TicketCalculation = "ticketCalculation"
    
    
    let API_SaveCard = "saveCard"
    let API_GetCardList = "getCardList"
    let API_GetCardToken = "getCardToken"
    let API_purchasePackagePlan = "purchase_package_plan"
    let API_FeaturedPlan = "makeFeatured"
    let API_SongFeaturedPlan = "checkFeaturedPlan"
    let API_PromotionalPlan = "promotional"
    let API_FeaturedArtist = "Artist"
    let API_CurrentPlan = "current_plan_detail"
    let API_AllPayment = "allPayments"
    let API_FeaturedSongList = "Songs"
    let API_TicketScan = "ticketScan"
    let API_SoldOutTicket = "soldOutTicket"
    let AppUserDefaults = UserDefaults.standard
    func printData(_ dataValue : Any ){
        if debug_mode == 1 {
            print(dataValue)
        }
    }
}
