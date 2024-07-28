package com.example.fpi.controller.user;

import com.example.fpi.domain.dto.board.CommunityDTO;
import com.example.fpi.domain.dto.board.UserCommunityListDTO;
import com.example.fpi.domain.dto.certify.CardInfoDTO;
import com.example.fpi.domain.dto.certify.CareerInfoDTO;
import com.example.fpi.domain.dto.certify.CertifyDTO;
import com.example.fpi.domain.dto.main.CategoryListDTO;
import com.example.fpi.domain.dto.pro.ProDTO;
import com.example.fpi.domain.dto.user.CouponDTO;
import com.example.fpi.domain.dto.user.CouponListDTO;
import com.example.fpi.domain.dto.user.UserDTO;
import com.example.fpi.domain.dto.user.UserEditDTO;
import com.example.fpi.domain.oauth.CustomOAuth2User;
import com.example.fpi.domain.vo.certify.CareerInfoVO;
import com.example.fpi.domain.vo.main.CategoryListVO;
import com.example.fpi.domain.vo.user.UserVO;
import com.example.fpi.mapper.user.CertifyMapper;
import com.example.fpi.mapper.user.CouponMapper;
import com.example.fpi.mapper.user.UserMapper;
import com.example.fpi.service.main.FormService;
import com.example.fpi.service.pro.ProService;
import com.example.fpi.service.user.ActiveService;
import com.example.fpi.service.user.CertifyService;
import com.example.fpi.service.user.CouponService;
import com.example.fpi.service.user.UserService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

@Controller
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserMypageController {
    private final UserService userService;
    private final CouponService couponService;
    private final CertifyService certifyService;
    private final FormService formService;
    private final ActiveService activeService;


    //    마이페이지
    @GetMapping("/mypage")
    public String mypage(@AuthenticationPrincipal CustomOAuth2User customOAuth2User, Model model) {
//        현재사용자의 인증객체 가져옴
        String userId = customOAuth2User.getUserId();
        model.addAttribute("mypage",userService.detailUser(userId));
        return "user/mypage/user_mypage";

    }
// 상세페이지
    @GetMapping("/detail")
    public String detail(@AuthenticationPrincipal CustomOAuth2User customOAuth2User, Model model) {

        String userId = customOAuth2User.getUserId();
        model.addAttribute("detail", userService.detailUser(userId));

        return "user/mypage/user_detail";

    }

//    쿠폰함
    @GetMapping("/couponlist")
    public String coupon(@AuthenticationPrincipal CustomOAuth2User customOAuth2User,Model model){
        String userId = customOAuth2User.getUserId();
        System.out.println();

        List<CouponDTO> coupons = couponService.couponlist(userId);

        for(CouponDTO coupon : coupons){
            coupon.setCount(couponService.useCouponCount(userId));
        }


        model.addAttribute("coupons",coupons);
        System.out.println(coupons);

        return "user/mypage/coupon";
    }

    //    유저정보 수정 폼으로 정보 가지고이동
    @GetMapping("/edit")
    public String edit(@AuthenticationPrincipal CustomOAuth2User customOAuth2User, Model model) {
        String userId = customOAuth2User.getUserId();
        model.addAttribute("edit", userService.detailUser(userId));

        return "user/mypage/user_edit";
    }

//html에서 edit에 정보가 담겨있음,getter에서 edit에 담아서 넘겨줌
    @PostMapping("/edit")
    public String edit(UserDTO edit) {

        String region = edit.getRegion();
        String city = edit.getCity();
        edit.setLocationId(formService.selectLocation(region,city)); //선택한 지역의 pk알아내고 추가하기위해 필요


        CategoryListDTO categoryListDTO = new CategoryListDTO();
        categoryListDTO.setCategoryId(edit.getCategoryId());
        categoryListDTO.setUserId(edit.getUserId());

        userService.editCategory(categoryListDTO);  //선택한 카테고리 관리테이블

        userService.editUser(edit);
        return "redirect:/user/detail";
    }

//    전문가 인증폼으로 이동
    @GetMapping("/certify")
    public String certifyForm(Model model) {
//        List<CareerInfoDTO> awards = new ArrayList<>();
        model.addAttribute("certify", new CertifyDTO());
//        model.addAttribute("awards",new List<CareerInfoDTO> ());
        return "user/mypage/certify";
    }

    @PostMapping("/certify")
    public String certify(CertifyDTO certify, @AuthenticationPrincipal CustomOAuth2User customOAuth2User,
                          @RequestParam String certiOrgan,
                          @RequestParam String certiNum,
                          @RequestParam List<MultipartFile> files,
                          @RequestParam MultipartFile proProfile,HttpSession session) throws IOException {


        String userId = customOAuth2User.getUserId();
        String region = certify.getRegion();
        String city = certify.getCity();

        certify.setUserId(userId);
        certify.setLocationId(formService.selectLocation(region,city));

        certifyService.addCertify(certify,files,proProfile,certiOrgan,certiNum);

        session.setAttribute("userProApproval",userService.detailUser(userId).getUserProApproval());
        return "redirect:/user/mypage";

    }


    //유저 탈퇴
    @PostMapping("/delete")
    public String delete(@RequestParam String userId,
                         @RequestParam String userName,
                         RedirectAttributes redirectAttributes,
                         HttpSession session) {

        String dbUserName = userService.getUserName(userId);

        //        db에 저장된 이름이랑 받아온 input에 입력된 이름이랑 비교
        if (userName.equals(dbUserName)) {
            userService.deleteUser(userId,userName);
//            헤더에서 이걸 이용해서 이름을 읽어들이기때문에
//            탈퇴후 헤더에서도 이름을 삭제해주기 위해 session을 비워줘야함
            session.invalidate();
            return "redirect:/main";
        } else {
            //            일치하지않을때 에러모달 띄우기 위한 코드
            redirectAttributes.addFlashAttribute("error", true);
            return "redirect:/user/detail";
        }
    }

//    @GetMapping({"/activeList/community","/activeList/review","/activeList/comment"})
//    public String active(@AuthenticationPrincipal CustomOAuth2User customOAuth2User,
//                         @RequestParam(value="page", defaultValue = "1")int page,
//                         @RequestParam (value="pageSize", defaultValue = "8")int pageSize,
//                         Model model) {
//        String userId = customOAuth2User.getUserId();
//        int totalCommu = activeService.countUserCommu(userId); //전체 게시글
//        int totalPages =(int) Math.ceil((double)totalCommu/pageSize); //페이지 수
//
//        List<UserCommunityListDTO> lists = activeService.selectUserCommuList(userId,page,pageSize);
//        int pageGroupSize=5; //페이지 그룹
//        int startPage=((page-1)/pageGroupSize)* pageGroupSize +1; //그룹의 시작페이지 구함
//        int endPage= Math.min(startPage+pageGroupSize -1,totalPages); //
//
//        model.addAttribute("lists",lists);
//        model.addAttribute("currentPage",page);
//        model.addAttribute("pageSize",pageSize);
//        model.addAttribute("totalPages",totalPages);
//        model.addAttribute("startPage",startPage);
//        model.addAttribute("endPage",endPage);
//
//
//        return "/user/mypage/creationList1";
//    }
    @GetMapping("/activeList")
    public String active(@AuthenticationPrincipal CustomOAuth2User customOAuth2User,
                         @RequestParam(value="page", defaultValue = "1")int page,
                         @RequestParam (value="pageSize", defaultValue = "8")int pageSize,
                         Model model) {
        String userId = customOAuth2User.getUserId();
        int totalCommu = activeService.countUserCommu(userId); //전체 게시글
        int totalPages =(int) Math.ceil((double)totalCommu/pageSize); //페이지 수

        List<UserCommunityListDTO> lists = activeService.selectUserCommuList(userId,page,pageSize);
        int pageGroupSize=5; //페이지 그룹
        int startPage=((page-1)/pageGroupSize)* pageGroupSize +1; //그룹의 시작페이지 구함
        int endPage= Math.min(startPage+pageGroupSize -1,totalPages); //

        model.addAttribute("lists",lists);
        model.addAttribute("currentPage",page);
        model.addAttribute("pageSize",pageSize);
        model.addAttribute("totalPages",totalPages);
        model.addAttribute("startPage",startPage);
        model.addAttribute("endPage",endPage);


        return "/user/mypage/creationList1";
    }



}
