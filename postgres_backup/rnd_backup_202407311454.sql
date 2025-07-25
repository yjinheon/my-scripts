PGDMP      6                |            rnd    16.3    16.3 &   ~           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16819    rnd    DATABASE     o   CREATE DATABASE rnd WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';
    DROP DATABASE rnd;
                rnduser    false                        2615    17221    scvdb    SCHEMA        CREATE SCHEMA scvdb;
    DROP SCHEMA scvdb;
                rnduser    false            �            1259    17223 	   configure    TABLE     �  CREATE TABLE scvdb.configure (
    sno bigint NOT NULL,
    prj_code character varying(10) NOT NULL,
    conf_key character varying(30) NOT NULL,
    conf_value character varying(1000),
    description character varying(50),
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.configure;
       scvdb         heap    rnduser    false    6            �           0    0    COLUMN configure.frst_rg_dt    COMMENT     F   COMMENT ON COLUMN scvdb.configure.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    217            �           0    0    COLUMN configure.frst_rg_id    COMMENT     C   COMMENT ON COLUMN scvdb.configure.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    217            �           0    0    COLUMN configure.last_md_dt    COMMENT     F   COMMENT ON COLUMN scvdb.configure.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    217            �           0    0    COLUMN configure.last_md_id    COMMENT     C   COMMENT ON COLUMN scvdb.configure.last_md_id IS '최종수정자';
          scvdb          rnduser    false    217            �            1259    17222    configure_sno_seq    SEQUENCE     y   CREATE SEQUENCE scvdb.configure_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE scvdb.configure_sno_seq;
       scvdb          rnduser    false    6    217            �           0    0    configure_sno_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE scvdb.configure_sno_seq OWNED BY scvdb.configure.sno;
          scvdb          rnduser    false    216            �            1259    17330    gs_apt_trade    TABLE     M  CREATE TABLE scvdb.gs_apt_trade (
    apt_dling_rcptn_id bigint NOT NULL,
    estate_adlng_tnthw_unit_amt character varying(20),
    estate_actr_yr character varying(4),
    estate_ctrt_yr character varying(4),
    stdg_addr character varying(200),
    apt_nm character varying(300),
    estate_ctrt_mm character varying(2),
    estate_ctrt_de character varying(8),
    xuar character varying(19),
    lotno_addr character varying(200),
    stdg_cd character varying(10),
    bldg_flr_cnt character varying(4),
    frst_reg_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    frst_rgtr_id character varying(20) DEFAULT 'SYSTEM'::character varying NOT NULL,
    last_mdfcn_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_mdfr_id character varying(20) DEFAULT 'SYSTEM'::character varying NOT NULL
);
    DROP TABLE scvdb.gs_apt_trade;
       scvdb         heap    rnduser    false    6            �           0    0    TABLE gs_apt_trade    COMMENT     N   COMMENT ON TABLE scvdb.gs_apt_trade IS '연계_아파트매매신고_내역';
          scvdb          rnduser    false    237            �           0    0 &   COLUMN gs_apt_trade.apt_dling_rcptn_id    COMMENT     ]   COMMENT ON COLUMN scvdb.gs_apt_trade.apt_dling_rcptn_id IS '아파트매매수신아이디';
          scvdb          rnduser    false    237            �           0    0 /   COLUMN gs_apt_trade.estate_adlng_tnthw_unit_amt    COMMENT     T   COMMENT ON COLUMN scvdb.gs_apt_trade.estate_adlng_tnthw_unit_amt IS '거래금액';
          scvdb          rnduser    false    237            �           0    0 "   COLUMN gs_apt_trade.estate_actr_yr    COMMENT     G   COMMENT ON COLUMN scvdb.gs_apt_trade.estate_actr_yr IS '건축년도';
          scvdb          rnduser    false    237            �           0    0 "   COLUMN gs_apt_trade.estate_ctrt_yr    COMMENT     >   COMMENT ON COLUMN scvdb.gs_apt_trade.estate_ctrt_yr IS '년';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.stdg_addr    COMMENT     ?   COMMENT ON COLUMN scvdb.gs_apt_trade.stdg_addr IS '법정동';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.apt_nm    COMMENT     <   COMMENT ON COLUMN scvdb.gs_apt_trade.apt_nm IS '아파트';
          scvdb          rnduser    false    237            �           0    0 "   COLUMN gs_apt_trade.estate_ctrt_mm    COMMENT     >   COMMENT ON COLUMN scvdb.gs_apt_trade.estate_ctrt_mm IS '월';
          scvdb          rnduser    false    237            �           0    0 "   COLUMN gs_apt_trade.estate_ctrt_de    COMMENT     >   COMMENT ON COLUMN scvdb.gs_apt_trade.estate_ctrt_de IS '일';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.xuar    COMMENT     =   COMMENT ON COLUMN scvdb.gs_apt_trade.xuar IS '전용면적';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.lotno_addr    COMMENT     =   COMMENT ON COLUMN scvdb.gs_apt_trade.lotno_addr IS '지번';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.stdg_cd    COMMENT     @   COMMENT ON COLUMN scvdb.gs_apt_trade.stdg_cd IS '지역코드';
          scvdb          rnduser    false    237            �           0    0     COLUMN gs_apt_trade.bldg_flr_cnt    COMMENT     <   COMMENT ON COLUMN scvdb.gs_apt_trade.bldg_flr_cnt IS '층';
          scvdb          rnduser    false    237            �           0    0    COLUMN gs_apt_trade.frst_reg_dt    COMMENT     J   COMMENT ON COLUMN scvdb.gs_apt_trade.frst_reg_dt IS '최초등록일시';
          scvdb          rnduser    false    237            �           0    0     COLUMN gs_apt_trade.frst_rgtr_id    COMMENT     Q   COMMENT ON COLUMN scvdb.gs_apt_trade.frst_rgtr_id IS '최초등록자아이디';
          scvdb          rnduser    false    237            �           0    0 !   COLUMN gs_apt_trade.last_mdfcn_dt    COMMENT     L   COMMENT ON COLUMN scvdb.gs_apt_trade.last_mdfcn_dt IS '최종수정일시';
          scvdb          rnduser    false    237            �           0    0     COLUMN gs_apt_trade.last_mdfr_id    COMMENT     Q   COMMENT ON COLUMN scvdb.gs_apt_trade.last_mdfr_id IS '최종수정자아이디';
          scvdb          rnduser    false    237            �            1259    17329 #   gs_apt_trade_apt_dling_rcptn_id_seq    SEQUENCE     �   CREATE SEQUENCE scvdb.gs_apt_trade_apt_dling_rcptn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE scvdb.gs_apt_trade_apt_dling_rcptn_id_seq;
       scvdb          rnduser    false    6    237            �           0    0 #   gs_apt_trade_apt_dling_rcptn_id_seq    SEQUENCE OWNED BY     i   ALTER SEQUENCE scvdb.gs_apt_trade_apt_dling_rcptn_id_seq OWNED BY scvdb.gs_apt_trade.apt_dling_rcptn_id;
          scvdb          rnduser    false    236            �            1259    17344    gs_eleccar_charge    TABLE       CREATE TABLE scvdb.gs_eleccar_charge (
    elctrc_auto_chgstn_id bigint NOT NULL,
    chgstn_nm character varying(100),
    chgstn_id character varying(8),
    chgr_id character varying(2),
    chgr_typ character varying(2),
    chgr_addr character varying(150),
    chgr_addr_dtl_cn character varying(200),
    lat character varying(15),
    lot character varying(15),
    utztn_psblty_hr character varying(50),
    inst_id character varying(2),
    inst_nm character varying(50),
    oper_inst_nm character varying(50),
    oper_inst_cttpc character varying(20),
    chgr_stts character varying(1),
    stts_updt_dt character varying(14),
    lst_chg_bgng_dt character varying(14),
    lst_chg_end_dt character varying(14),
    chgng_bgng_dt character varying(14),
    chg_cpct character varying(20),
    chg_way character varying(10),
    ctpv_cd character varying(2),
    stdg_cd character varying(5),
    chgstn_se_cd character varying(2),
    chgstn_se_dtl_cd character varying(4),
    prk_fee_free character varying(1),
    chgstn_guide character varying(200),
    user_lmt character varying(1),
    utztn_lmt_rsn character varying(100),
    del_yn character varying(1),
    del_rsn character varying(100),
    frst_reg_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    frst_rgtr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL,
    last_mdfcn_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_mdfr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL
);
 $   DROP TABLE scvdb.gs_eleccar_charge;
       scvdb         heap    rnduser    false    6            �           0    0    TABLE gs_eleccar_charge    COMMENT     P   COMMENT ON TABLE scvdb.gs_eleccar_charge IS '연계_전기차충전소_내역';
          scvdb          rnduser    false    239            �           0    0 .   COLUMN gs_eleccar_charge.elctrc_auto_chgstn_id    COMMENT     b   COMMENT ON COLUMN scvdb.gs_eleccar_charge.elctrc_auto_chgstn_id IS '전기차충전소아이디';
          scvdb          rnduser    false    239            �           0    0 "   COLUMN gs_eleccar_charge.chgstn_nm    COMMENT     N   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgstn_nm IS 'statNm-충전소명';
          scvdb          rnduser    false    239            �           0    0 "   COLUMN gs_eleccar_charge.chgstn_id    COMMENT     T   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgstn_id IS 'statId-충전소아이디';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.chgr_id    COMMENT     S   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgr_id IS 'chgerId-충전기아이디';
          scvdb          rnduser    false    239            �           0    0 !   COLUMN gs_eleccar_charge.chgr_typ    COMMENT     S   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgr_typ IS 'chgerType-총전기타입';
          scvdb          rnduser    false    239            �           0    0 "   COLUMN gs_eleccar_charge.chgr_addr    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgr_addr IS 'addr-충전소주소';
          scvdb          rnduser    false    239            �           0    0 )   COLUMN gs_eleccar_charge.chgr_addr_dtl_cn    COMMENT     f   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgr_addr_dtl_cn IS 'location-충전소주소상세내용';
          scvdb          rnduser    false    239            �           0    0    COLUMN gs_eleccar_charge.lat    COMMENT     ?   COMMENT ON COLUMN scvdb.gs_eleccar_charge.lat IS 'lat-위도';
          scvdb          rnduser    false    239            �           0    0    COLUMN gs_eleccar_charge.lot    COMMENT     ?   COMMENT ON COLUMN scvdb.gs_eleccar_charge.lot IS 'lng-경도';
          scvdb          rnduser    false    239            �           0    0 (   COLUMN gs_eleccar_charge.utztn_psblty_hr    COMMENT     [   COMMENT ON COLUMN scvdb.gs_eleccar_charge.utztn_psblty_hr IS 'useTime-이용가능시간';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.inst_id    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.inst_id IS 'busiId-기관아이디';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.inst_nm    COMMENT     F   COMMENT ON COLUMN scvdb.gs_eleccar_charge.inst_nm IS 'bnm-기관명';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.oper_inst_nm    COMMENT     T   COMMENT ON COLUMN scvdb.gs_eleccar_charge.oper_inst_nm IS 'busiNm-운영기관명';
          scvdb          rnduser    false    239            �           0    0 (   COLUMN gs_eleccar_charge.oper_inst_cttpc    COMMENT     _   COMMENT ON COLUMN scvdb.gs_eleccar_charge.oper_inst_cttpc IS 'busiCall-운영기관연락처';
          scvdb          rnduser    false    239            �           0    0 "   COLUMN gs_eleccar_charge.chgr_stts    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgr_stts IS 'stat-충전기상태';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.stts_updt_dt    COMMENT     Z   COMMENT ON COLUMN scvdb.gs_eleccar_charge.stts_updt_dt IS 'statUpdDt-상태갱신일시';
          scvdb          rnduser    false    239            �           0    0 (   COLUMN gs_eleccar_charge.lst_chg_bgng_dt    COMMENT     e   COMMENT ON COLUMN scvdb.gs_eleccar_charge.lst_chg_bgng_dt IS 'lastTsdt-마지막충전시작일시';
          scvdb          rnduser    false    239            �           0    0 '   COLUMN gs_eleccar_charge.lst_chg_end_dt    COMMENT     d   COMMENT ON COLUMN scvdb.gs_eleccar_charge.lst_chg_end_dt IS 'lastTedt-마지막충전종료일시';
          scvdb          rnduser    false    239            �           0    0 &   COLUMN gs_eleccar_charge.chgng_bgng_dt    COMMENT     \   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgng_bgng_dt IS 'nowTsdt-충전중시작일시';
          scvdb          rnduser    false    239            �           0    0 !   COLUMN gs_eleccar_charge.chg_cpct    COMMENT     M   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chg_cpct IS 'output-충전용량';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.chg_way    COMMENT     L   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chg_way IS 'method-충전방식';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.ctpv_cd    COMMENT     K   COMMENT ON COLUMN scvdb.gs_eleccar_charge.ctpv_cd IS 'zcode-시도코드';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.stdg_cd    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.stdg_cd IS 'zscode-시군구코드';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.chgstn_se_cd    COMMENT     X   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgstn_se_cd IS 'kind-충전소구분코드';
          scvdb          rnduser    false    239            �           0    0 )   COLUMN gs_eleccar_charge.chgstn_se_dtl_cd    COMMENT     h   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgstn_se_dtl_cd IS 'kindDetail-충전소구분상세코드';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.prk_fee_free    COMMENT     Y   COMMENT ON COLUMN scvdb.gs_eleccar_charge.prk_fee_free IS 'parkingFree-주차료무료';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.chgstn_guide    COMMENT     R   COMMENT ON COLUMN scvdb.gs_eleccar_charge.chgstn_guide IS 'note-충전소안내';
          scvdb          rnduser    false    239            �           0    0 !   COLUMN gs_eleccar_charge.user_lmt    COMMENT     Q   COMMENT ON COLUMN scvdb.gs_eleccar_charge.user_lmt IS 'limitYn-이용자제한';
          scvdb          rnduser    false    239            �           0    0 &   COLUMN gs_eleccar_charge.utztn_lmt_rsn    COMMENT     ]   COMMENT ON COLUMN scvdb.gs_eleccar_charge.utztn_lmt_rsn IS 'limitDetail-이용제한사유';
          scvdb          rnduser    false    239            �           0    0    COLUMN gs_eleccar_charge.del_yn    COMMENT     J   COMMENT ON COLUMN scvdb.gs_eleccar_charge.del_yn IS 'delYn-삭제여부';
          scvdb          rnduser    false    239            �           0    0     COLUMN gs_eleccar_charge.del_rsn    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.del_rsn IS 'delDetail-삭제사유';
          scvdb          rnduser    false    239            �           0    0 $   COLUMN gs_eleccar_charge.frst_reg_dt    COMMENT     O   COMMENT ON COLUMN scvdb.gs_eleccar_charge.frst_reg_dt IS '최초등록일시';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.frst_rgtr_id    COMMENT     V   COMMENT ON COLUMN scvdb.gs_eleccar_charge.frst_rgtr_id IS '최초등록자아이디';
          scvdb          rnduser    false    239            �           0    0 &   COLUMN gs_eleccar_charge.last_mdfcn_dt    COMMENT     Q   COMMENT ON COLUMN scvdb.gs_eleccar_charge.last_mdfcn_dt IS '최종수정일시';
          scvdb          rnduser    false    239            �           0    0 %   COLUMN gs_eleccar_charge.last_mdfr_id    COMMENT     V   COMMENT ON COLUMN scvdb.gs_eleccar_charge.last_mdfr_id IS '최종수정자아이디';
          scvdb          rnduser    false    239            �            1259    17343 +   gs_eleccar_charge_elctrc_auto_chgstn_id_seq    SEQUENCE     �   CREATE SEQUENCE scvdb.gs_eleccar_charge_elctrc_auto_chgstn_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 A   DROP SEQUENCE scvdb.gs_eleccar_charge_elctrc_auto_chgstn_id_seq;
       scvdb          rnduser    false    239    6            �           0    0 +   gs_eleccar_charge_elctrc_auto_chgstn_id_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE scvdb.gs_eleccar_charge_elctrc_auto_chgstn_id_seq OWNED BY scvdb.gs_eleccar_charge.elctrc_auto_chgstn_id;
          scvdb          rnduser    false    238            �            1259    17357    gs_garden_rent    TABLE     t  CREATE TABLE scvdb.gs_garden_rent (
    garden_rent_id bigint NOT NULL,
    kcngdn_id character varying(10),
    oper_inst_cd character varying(50),
    kcngdn_nm character varying(300),
    ctpv_cd character varying(5),
    ctpv_nm character varying(40),
    kcngdn_sgg_no character varying(20),
    sgg_nm character varying(40),
    kcngdn_slnlt_addr character varying(2000),
    kcngdn_whole_sfc character varying(50),
    kcngdn_slnlt_sfc character varying(50),
    hmpg_addr character varying(2000),
    rcrt_prd_cn character varying(100),
    sbrs_cn character varying(1000),
    kcngdn_aply_mthd_cn character varying(1000),
    kcngdn_slnlt_prc_cn character varying(1000),
    lat character varying(50),
    lot character varying(50),
    reg_ymd character varying(8),
    mdfcn_ymd character varying(8),
    frst_reg_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    frst_rgtr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL,
    last_mdfcn_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_mdfr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL
);
 !   DROP TABLE scvdb.gs_garden_rent;
       scvdb         heap    rnduser    false    6            �           0    0    TABLE gs_garden_rent    COMMENT     M   COMMENT ON TABLE scvdb.gs_garden_rent IS '연계_텃밭분양정보_내역';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.kcngdn_id    COMMENT     G   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_id IS '텃밭아이디';
          scvdb          rnduser    false    241            �           0    0 "   COLUMN gs_garden_rent.oper_inst_cd    COMMENT     W   COMMENT ON COLUMN scvdb.gs_garden_rent.oper_inst_cd IS '운영기관코드_FARM_TYPE';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.kcngdn_nm    COMMENT     I   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_nm IS '텃밭명_FARM_NM';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.ctpv_cd    COMMENT     K   COMMENT ON COLUMN scvdb.gs_garden_rent.ctpv_cd IS '시도코드_AREA_LCD';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.ctpv_nm    COMMENT     H   COMMENT ON COLUMN scvdb.gs_garden_rent.ctpv_nm IS '시도명_AREA_LNM';
          scvdb          rnduser    false    241            �           0    0 #   COLUMN gs_garden_rent.kcngdn_sgg_no    COMMENT     Z   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_sgg_no IS '텃밭시군구번호_AREA_MCD';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.sgg_nm    COMMENT     J   COMMENT ON COLUMN scvdb.gs_garden_rent.sgg_nm IS '시군구명_AREA_MNM';
          scvdb          rnduser    false    241            �           0    0 '   COLUMN gs_garden_rent.kcngdn_slnlt_addr    COMMENT     [   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_slnlt_addr IS '텃밭분양주소_ADDRESS1';
          scvdb          rnduser    false    241            �           0    0 &   COLUMN gs_garden_rent.kcngdn_whole_sfc    COMMENT     `   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_whole_sfc IS '텃밭전체면적_FARM_AREA_INFO';
          scvdb          rnduser    false    241            �           0    0 &   COLUMN gs_garden_rent.kcngdn_slnlt_sfc    COMMENT     `   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_slnlt_sfc IS '텃밭분양면적_SELL_AREA_INFO';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.hmpg_addr    COMMENT     S   COMMENT ON COLUMN scvdb.gs_garden_rent.hmpg_addr IS '홈페이지주소_HOMEPAGE';
          scvdb          rnduser    false    241            �           0    0 !   COLUMN gs_garden_rent.rcrt_prd_cn    COMMENT     X   COMMENT ON COLUMN scvdb.gs_garden_rent.rcrt_prd_cn IS '모집기간내용_COLLEC_PROD';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.sbrs_cn    COMMENT     Q   COMMENT ON COLUMN scvdb.gs_garden_rent.sbrs_cn IS '부대시설내용_OFF_SITE';
          scvdb          rnduser    false    241            �           0    0 )   COLUMN gs_garden_rent.kcngdn_aply_mthd_cn    COMMENT     e   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_aply_mthd_cn IS '텃밭신청방법내용_APPLY_MTHD';
          scvdb          rnduser    false    241            �           0    0 )   COLUMN gs_garden_rent.kcngdn_slnlt_prc_cn    COMMENT     `   COMMENT ON COLUMN scvdb.gs_garden_rent.kcngdn_slnlt_prc_cn IS '텃밭분양가격내용_PRICE';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.lat    COMMENT     ?   COMMENT ON COLUMN scvdb.gs_garden_rent.lat IS '위도_POSLAT';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.lot    COMMENT     ?   COMMENT ON COLUMN scvdb.gs_garden_rent.lot IS '경도_POSLNG';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.reg_ymd    COMMENT     L   COMMENT ON COLUMN scvdb.gs_garden_rent.reg_ymd IS '등록일자_REGIST_DT';
          scvdb          rnduser    false    241            �           0    0    COLUMN gs_garden_rent.mdfcn_ymd    COMMENT     L   COMMENT ON COLUMN scvdb.gs_garden_rent.mdfcn_ymd IS '수정일자_UPDT_DT';
          scvdb          rnduser    false    241            �           0    0 !   COLUMN gs_garden_rent.frst_reg_dt    COMMENT     L   COMMENT ON COLUMN scvdb.gs_garden_rent.frst_reg_dt IS '최초등록일시';
          scvdb          rnduser    false    241            �           0    0 "   COLUMN gs_garden_rent.frst_rgtr_id    COMMENT     S   COMMENT ON COLUMN scvdb.gs_garden_rent.frst_rgtr_id IS '최초등록자아이디';
          scvdb          rnduser    false    241            �           0    0 #   COLUMN gs_garden_rent.last_mdfcn_dt    COMMENT     N   COMMENT ON COLUMN scvdb.gs_garden_rent.last_mdfcn_dt IS '최종수정일시';
          scvdb          rnduser    false    241            �           0    0 "   COLUMN gs_garden_rent.last_mdfr_id    COMMENT     S   COMMENT ON COLUMN scvdb.gs_garden_rent.last_mdfr_id IS '최종수정자아이디';
          scvdb          rnduser    false    241            �            1259    17356 !   gs_garden_rent_garden_rent_id_seq    SEQUENCE     �   CREATE SEQUENCE scvdb.gs_garden_rent_garden_rent_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE scvdb.gs_garden_rent_garden_rent_id_seq;
       scvdb          rnduser    false    241    6            �           0    0 !   gs_garden_rent_garden_rent_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE scvdb.gs_garden_rent_garden_rent_id_seq OWNED BY scvdb.gs_garden_rent.garden_rent_id;
          scvdb          rnduser    false    240            �            1259    17370    gs_policy_news    TABLE       CREATE TABLE scvdb.gs_policy_news (
    plcy_news_id bigint NOT NULL,
    news_id character varying(10),
    cns_stts character varying(1),
    chg_cunt character varying(5),
    chg_dt character varying(20),
    aprv_dt character varying(20),
    autzr_nm character varying(50),
    embgo_rmv_dt character varying(20),
    clsf_cd character varying(20),
    ttl character varying(400),
    sbttl1 character varying(200),
    sbttl2 character varying(200),
    sbttl3 character varying(200),
    news_cn_typ character varying(1),
    news_cn text,
    gvmdpt_nm character varying(20),
    reduce_img_url character varying(500),
    orgnl_img_url character varying(500),
    news_orgnl_url character varying(500),
    frst_reg_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    frst_rgtr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL,
    last_mdfcn_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_mdfr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL
);
 !   DROP TABLE scvdb.gs_policy_news;
       scvdb         heap    rnduser    false    6            �           0    0    TABLE gs_policy_news    COMMENT     G   COMMENT ON TABLE scvdb.gs_policy_news IS '연계_정책뉴스_내역';
          scvdb          rnduser    false    243            �           0    0 "   COLUMN gs_policy_news.plcy_news_id    COMMENT     P   COMMENT ON COLUMN scvdb.gs_policy_news.plcy_news_id IS '정책뉴스아이디';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.news_id    COMMENT     P   COMMENT ON COLUMN scvdb.gs_policy_news.news_id IS '기사아이디_NewsItemId';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.cns_stts    COMMENT     U   COMMENT ON COLUMN scvdb.gs_policy_news.cns_stts IS '콘텐츠상태_ContentsStatus';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.chg_cunt    COMMENT     L   COMMENT ON COLUMN scvdb.gs_policy_news.chg_cunt IS '변경횟수_ModifyId';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.chg_dt    COMMENT     I   COMMENT ON COLUMN scvdb.gs_policy_news.chg_dt IS '변경일_ModifyDate';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.aprv_dt    COMMENT     K   COMMENT ON COLUMN scvdb.gs_policy_news.aprv_dt IS '승인일_ApproveDate';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.autzr_nm    COMMENT     P   COMMENT ON COLUMN scvdb.gs_policy_news.autzr_nm IS '승인자명_ApproverName';
          scvdb          rnduser    false    243            �           0    0 "   COLUMN gs_policy_news.embgo_rmv_dt    COMMENT     Y   COMMENT ON COLUMN scvdb.gs_policy_news.embgo_rmv_dt IS '엠바고해제일_EmbargoDate';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.clsf_cd    COMMENT     O   COMMENT ON COLUMN scvdb.gs_policy_news.clsf_cd IS '분류코드_GroupingCode';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.ttl    COMMENT     >   COMMENT ON COLUMN scvdb.gs_policy_news.ttl IS '제목_Title';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.sbttl1    COMMENT     I   COMMENT ON COLUMN scvdb.gs_policy_news.sbttl1 IS '부제목1_SubTitle1';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.sbttl2    COMMENT     I   COMMENT ON COLUMN scvdb.gs_policy_news.sbttl2 IS '부제목2_SubTitle2';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.sbttl3    COMMENT     I   COMMENT ON COLUMN scvdb.gs_policy_news.sbttl3 IS '부제목3_SubTitle3';
          scvdb          rnduser    false    243            �           0    0 !   COLUMN gs_policy_news.news_cn_typ    COMMENT     Y   COMMENT ON COLUMN scvdb.gs_policy_news.news_cn_typ IS '기사내용형식_ContentsType';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.news_cn    COMMENT     O   COMMENT ON COLUMN scvdb.gs_policy_news.news_cn IS '기사내용_DataContents';
          scvdb          rnduser    false    243            �           0    0    COLUMN gs_policy_news.gvmdpt_nm    COMMENT     N   COMMENT ON COLUMN scvdb.gs_policy_news.gvmdpt_nm IS '부처명_MinisterCode';
          scvdb          rnduser    false    243            �           0    0 $   COLUMN gs_policy_news.reduce_img_url    COMMENT     _   COMMENT ON COLUMN scvdb.gs_policy_news.reduce_img_url IS '축소이미지주소_ThumbnailUrl';
          scvdb          rnduser    false    243            �           0    0 #   COLUMN gs_policy_news.orgnl_img_url    COMMENT     ]   COMMENT ON COLUMN scvdb.gs_policy_news.orgnl_img_url IS '원본이미지주소_OriginalUrl';
          scvdb          rnduser    false    243            �           0    0 $   COLUMN gs_policy_news.news_orgnl_url    COMMENT     ^   COMMENT ON COLUMN scvdb.gs_policy_news.news_orgnl_url IS '기사원문주소_OriginalimgUrl';
          scvdb          rnduser    false    243            �           0    0 !   COLUMN gs_policy_news.frst_reg_dt    COMMENT     L   COMMENT ON COLUMN scvdb.gs_policy_news.frst_reg_dt IS '최초등록일시';
          scvdb          rnduser    false    243            �           0    0 "   COLUMN gs_policy_news.frst_rgtr_id    COMMENT     S   COMMENT ON COLUMN scvdb.gs_policy_news.frst_rgtr_id IS '최초등록자아이디';
          scvdb          rnduser    false    243            �           0    0 #   COLUMN gs_policy_news.last_mdfcn_dt    COMMENT     N   COMMENT ON COLUMN scvdb.gs_policy_news.last_mdfcn_dt IS '최종수정일시';
          scvdb          rnduser    false    243            �           0    0 "   COLUMN gs_policy_news.last_mdfr_id    COMMENT     S   COMMENT ON COLUMN scvdb.gs_policy_news.last_mdfr_id IS '최종수정자아이디';
          scvdb          rnduser    false    243            �            1259    17369    gs_policy_news_plcy_news_id_seq    SEQUENCE     �   CREATE SEQUENCE scvdb.gs_policy_news_plcy_news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE scvdb.gs_policy_news_plcy_news_id_seq;
       scvdb          rnduser    false    6    243            �           0    0    gs_policy_news_plcy_news_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE scvdb.gs_policy_news_plcy_news_id_seq OWNED BY scvdb.gs_policy_news.plcy_news_id;
          scvdb          rnduser    false    242            �            1259    17383    gs_worknet_info    TABLE       CREATE TABLE scvdb.gs_worknet_info (
    gs_worknet_info_id bigint NOT NULL,
    stswnt_cert_no character varying(16) NOT NULL,
    co_nm character varying(100),
    emplmt_nm character varying(300),
    wgs_se_nm character varying(10),
    salary_amt character varying(30),
    min_salary_amt character varying(17),
    max_salary_amt character varying(17),
    work_rgn_addr character varying(100),
    work_shap_se_nm character varying(20),
    min_acbg_se_nm character varying(20),
    max_acbg_se_nm character varying(20),
    wkep_se_nm character varying(200),
    reg_ymd character varying(8),
    skjob_ddln_ymd character varying(40),
    info_pvsn_nm character varying(100),
    url_addr character varying(2000),
    plcwrk_zip character varying(6),
    plcwrk_road_nm_addr character varying(2000),
    plcwrk_bass_addr character varying(2000),
    plcwrk_daddr character varying(200),
    skjob_emplmt_shap_no character varying(10),
    skjob_ocpt_no character varying(6),
    frst_reg_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    frst_rgtr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL,
    last_mdfcn_dt timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_mdfr_id character varying(20) DEFAULT 'LNK'::character varying NOT NULL
);
 "   DROP TABLE scvdb.gs_worknet_info;
       scvdb         heap    rnduser    false    6            �           0    0    TABLE gs_worknet_info    COMMENT     Q   COMMENT ON TABLE scvdb.gs_worknet_info IS '연계_워크넷채용정보_내역';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.stswnt_cert_no    COMMENT     ]   COMMENT ON COLUMN scvdb.gs_worknet_info.stswnt_cert_no IS '구인인증번호_wantedAuthNo';
          scvdb          rnduser    false    245            �           0    0    COLUMN gs_worknet_info.co_nm    COMMENT     F   COMMENT ON COLUMN scvdb.gs_worknet_info.co_nm IS '회사명_company';
          scvdb          rnduser    false    245            �           0    0     COLUMN gs_worknet_info.emplmt_nm    COMMENT     H   COMMENT ON COLUMN scvdb.gs_worknet_info.emplmt_nm IS '채용명_title';
          scvdb          rnduser    false    245            �           0    0     COLUMN gs_worknet_info.wgs_se_nm    COMMENT     P   COMMENT ON COLUMN scvdb.gs_worknet_info.wgs_se_nm IS '임금구분명_salTpNm';
          scvdb          rnduser    false    245            �           0    0 !   COLUMN gs_worknet_info.salary_amt    COMMENT     J   COMMENT ON COLUMN scvdb.gs_worknet_info.salary_amt IS '급여금액_sal';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.min_salary_amt    COMMENT     W   COMMENT ON COLUMN scvdb.gs_worknet_info.min_salary_amt IS '최소급여금액_minSal';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.max_salary_amt    COMMENT     W   COMMENT ON COLUMN scvdb.gs_worknet_info.max_salary_amt IS '최대급여금액_maxSal';
          scvdb          rnduser    false    245            �           0    0 $   COLUMN gs_worknet_info.work_rgn_addr    COMMENT     V   COMMENT ON COLUMN scvdb.gs_worknet_info.work_rgn_addr IS '근무지역주소_region';
          scvdb          rnduser    false    245            �           0    0 &   COLUMN gs_worknet_info.work_shap_se_nm    COMMENT     `   COMMENT ON COLUMN scvdb.gs_worknet_info.work_shap_se_nm IS '근무형태구분명_holidayTpNm';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.min_acbg_se_nm    COMMENT     \   COMMENT ON COLUMN scvdb.gs_worknet_info.min_acbg_se_nm IS '최소학력구분명_minEdubg';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.max_acbg_se_nm    COMMENT     \   COMMENT ON COLUMN scvdb.gs_worknet_info.max_acbg_se_nm IS '최대학력구분명_maxEdubg';
          scvdb          rnduser    false    245            �           0    0 !   COLUMN gs_worknet_info.wkep_se_nm    COMMENT     P   COMMENT ON COLUMN scvdb.gs_worknet_info.wkep_se_nm IS '경력구분명_career';
          scvdb          rnduser    false    245            �           0    0    COLUMN gs_worknet_info.reg_ymd    COMMENT     I   COMMENT ON COLUMN scvdb.gs_worknet_info.reg_ymd IS '등록일자_regDt';
          scvdb          rnduser    false    245            �           0    0 %   COLUMN gs_worknet_info.skjob_ddln_ymd    COMMENT     [   COMMENT ON COLUMN scvdb.gs_worknet_info.skjob_ddln_ymd IS '일자리마감일자_closeDt';
          scvdb          rnduser    false    245            �           0    0 #   COLUMN gs_worknet_info.info_pvsn_nm    COMMENT     S   COMMENT ON COLUMN scvdb.gs_worknet_info.info_pvsn_nm IS '정보제공명_infoSvc';
          scvdb          rnduser    false    245                        0    0    COLUMN gs_worknet_info.url_addr    COMMENT     O   COMMENT ON COLUMN scvdb.gs_worknet_info.url_addr IS 'URL주소_wantedInfoUrl';
          scvdb          rnduser    false    245                       0    0 !   COLUMN gs_worknet_info.plcwrk_zip    COMMENT     U   COMMENT ON COLUMN scvdb.gs_worknet_info.plcwrk_zip IS '근무지우편번호_zipCd';
          scvdb          rnduser    false    245                       0    0 *   COLUMN gs_worknet_info.plcwrk_road_nm_addr    COMMENT     d   COMMENT ON COLUMN scvdb.gs_worknet_info.plcwrk_road_nm_addr IS '근무지도로명주소_strtnmCd';
          scvdb          rnduser    false    245                       0    0 '   COLUMN gs_worknet_info.plcwrk_bass_addr    COMMENT     _   COMMENT ON COLUMN scvdb.gs_worknet_info.plcwrk_bass_addr IS '근무지기본주소_basicAddr';
          scvdb          rnduser    false    245                       0    0 #   COLUMN gs_worknet_info.plcwrk_daddr    COMMENT     \   COMMENT ON COLUMN scvdb.gs_worknet_info.plcwrk_daddr IS '근무지상세주소_detailAddr';
          scvdb          rnduser    false    245                       0    0 +   COLUMN gs_worknet_info.skjob_emplmt_shap_no    COMMENT     g   COMMENT ON COLUMN scvdb.gs_worknet_info.skjob_emplmt_shap_no IS '일자리채용형태번호_empTpCd';
          scvdb          rnduser    false    245                       0    0 $   COLUMN gs_worknet_info.skjob_ocpt_no    COMMENT     Y   COMMENT ON COLUMN scvdb.gs_worknet_info.skjob_ocpt_no IS '일자리직종번호_jobsCd';
          scvdb          rnduser    false    245                       0    0 "   COLUMN gs_worknet_info.frst_reg_dt    COMMENT     M   COMMENT ON COLUMN scvdb.gs_worknet_info.frst_reg_dt IS '최초등록일시';
          scvdb          rnduser    false    245                       0    0 #   COLUMN gs_worknet_info.frst_rgtr_id    COMMENT     T   COMMENT ON COLUMN scvdb.gs_worknet_info.frst_rgtr_id IS '최초등록자아이디';
          scvdb          rnduser    false    245            	           0    0 $   COLUMN gs_worknet_info.last_mdfcn_dt    COMMENT     O   COMMENT ON COLUMN scvdb.gs_worknet_info.last_mdfcn_dt IS '최종수정일시';
          scvdb          rnduser    false    245            
           0    0 #   COLUMN gs_worknet_info.last_mdfr_id    COMMENT     T   COMMENT ON COLUMN scvdb.gs_worknet_info.last_mdfr_id IS '최종수정자아이디';
          scvdb          rnduser    false    245            �            1259    17382 &   gs_worknet_info_gs_worknet_info_id_seq    SEQUENCE     �   CREATE SEQUENCE scvdb.gs_worknet_info_gs_worknet_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE scvdb.gs_worknet_info_gs_worknet_info_id_seq;
       scvdb          rnduser    false    245    6                       0    0 &   gs_worknet_info_gs_worknet_info_id_seq    SEQUENCE OWNED BY     o   ALTER SEQUENCE scvdb.gs_worknet_info_gs_worknet_info_id_seq OWNED BY scvdb.gs_worknet_info.gs_worknet_info_id;
          scvdb          rnduser    false    244            �            1259    17232    job_list    TABLE     �  CREATE TABLE scvdb.job_list (
    sender_id character varying(40) NOT NULL,
    vehicle_id character varying(40) NOT NULL,
    collect_class character varying(1) DEFAULT 'D'::character varying NOT NULL,
    parent_id character varying(40),
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.job_list;
       scvdb         heap    rnduser    false    6                       0    0    COLUMN job_list.frst_rg_dt    COMMENT     E   COMMENT ON COLUMN scvdb.job_list.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    218                       0    0    COLUMN job_list.frst_rg_id    COMMENT     B   COMMENT ON COLUMN scvdb.job_list.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    218                       0    0    COLUMN job_list.last_md_dt    COMMENT     E   COMMENT ON COLUMN scvdb.job_list.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    218                       0    0    COLUMN job_list.last_md_id    COMMENT     B   COMMENT ON COLUMN scvdb.job_list.last_md_id IS '최종수정자';
          scvdb          rnduser    false    218            �            1259    17239    job_mapper_list    TABLE     �  CREATE TABLE scvdb.job_mapper_list (
    sno bigint NOT NULL,
    sender_id character varying(40) NOT NULL,
    input_param character varying(50) NOT NULL,
    column_mapper character varying(50) NOT NULL,
    merge_se character varying(1) DEFAULT 'I'::character varying NOT NULL,
    tab_name character varying(100),
    delete_key character varying(1) DEFAULT 'N'::character varying NOT NULL,
    delete_option character varying(10) DEFAULT 'NONE'::character varying NOT NULL,
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
 "   DROP TABLE scvdb.job_mapper_list;
       scvdb         heap    rnduser    false    6                       0    0 !   COLUMN job_mapper_list.frst_rg_dt    COMMENT     L   COMMENT ON COLUMN scvdb.job_mapper_list.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    220                       0    0 !   COLUMN job_mapper_list.frst_rg_id    COMMENT     I   COMMENT ON COLUMN scvdb.job_mapper_list.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    220                       0    0 !   COLUMN job_mapper_list.last_md_dt    COMMENT     L   COMMENT ON COLUMN scvdb.job_mapper_list.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    220                       0    0 !   COLUMN job_mapper_list.last_md_id    COMMENT     I   COMMENT ON COLUMN scvdb.job_mapper_list.last_md_id IS '최종수정자';
          scvdb          rnduser    false    220            �            1259    17238    job_mapper_list_sno_seq    SEQUENCE        CREATE SEQUENCE scvdb.job_mapper_list_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE scvdb.job_mapper_list_sno_seq;
       scvdb          rnduser    false    220    6                       0    0    job_mapper_list_sno_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE scvdb.job_mapper_list_sno_seq OWNED BY scvdb.job_mapper_list.sno;
          scvdb          rnduser    false    219            �            1259    17249    member    TABLE       CREATE TABLE scvdb.member (
    member_id bigint NOT NULL,
    login_id character varying(50) NOT NULL,
    login_pwd character varying(500) NOT NULL,
    user_name character varying(50) NOT NULL,
    user_email character varying(50) NOT NULL,
    user_role character varying(20) DEFAULT 'ROLE_TEMPORARY_USER'::character varying NOT NULL,
    user_phone_number character varying(20),
    profile_picture_url character varying(200),
    account_non_locked boolean DEFAULT true,
    fail_count integer DEFAULT 0,
    lock_time timestamp without time zone,
    locked boolean DEFAULT false,
    fail_attempt integer,
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.member;
       scvdb         heap    rnduser    false    6                       0    0    COLUMN member.frst_rg_dt    COMMENT     C   COMMENT ON COLUMN scvdb.member.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    222                       0    0    COLUMN member.frst_rg_id    COMMENT     @   COMMENT ON COLUMN scvdb.member.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    222                       0    0    COLUMN member.last_md_dt    COMMENT     C   COMMENT ON COLUMN scvdb.member.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    222                       0    0    COLUMN member.last_md_id    COMMENT     @   COMMENT ON COLUMN scvdb.member.last_md_id IS '최종수정자';
          scvdb          rnduser    false    222            �            1259    17248    member_member_id_seq    SEQUENCE     |   CREATE SEQUENCE scvdb.member_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE scvdb.member_member_id_seq;
       scvdb          rnduser    false    6    222                       0    0    member_member_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE scvdb.member_member_id_seq OWNED BY scvdb.member.member_id;
          scvdb          rnduser    false    221            �            1259    17263    project    TABLE     �  CREATE TABLE scvdb.project (
    code character varying(4) NOT NULL,
    code_nm character varying(30) NOT NULL,
    up_code character varying(4),
    description character varying(50),
    del_yn character varying(1) DEFAULT 'N'::character varying NOT NULL,
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.project;
       scvdb         heap    rnduser    false    6                       0    0    COLUMN project.frst_rg_dt    COMMENT     D   COMMENT ON COLUMN scvdb.project.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    223                       0    0    COLUMN project.frst_rg_id    COMMENT     A   COMMENT ON COLUMN scvdb.project.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    223                       0    0    COLUMN project.last_md_dt    COMMENT     D   COMMENT ON COLUMN scvdb.project.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    223                       0    0    COLUMN project.last_md_id    COMMENT     A   COMMENT ON COLUMN scvdb.project.last_md_id IS '최종수정자';
          scvdb          rnduser    false    223            �            1259    17270    schedule    TABLE     �  CREATE TABLE scvdb.schedule (
    sno bigint NOT NULL,
    sender_id character varying(40) NOT NULL,
    cron_text character varying(50) NOT NULL,
    sch_desc character varying(100),
    sch_type character varying(10),
    sch_exec character varying(1) DEFAULT 'N'::character varying NOT NULL,
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.schedule;
       scvdb         heap    rnduser    false    6                       0    0    COLUMN schedule.frst_rg_dt    COMMENT     E   COMMENT ON COLUMN scvdb.schedule.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    225                       0    0    COLUMN schedule.frst_rg_id    COMMENT     B   COMMENT ON COLUMN scvdb.schedule.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    225                        0    0    COLUMN schedule.last_md_dt    COMMENT     E   COMMENT ON COLUMN scvdb.schedule.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    225            !           0    0    COLUMN schedule.last_md_id    COMMENT     B   COMMENT ON COLUMN scvdb.schedule.last_md_id IS '최종수정자';
          scvdb          rnduser    false    225            �            1259    17269    schedule_sno_seq    SEQUENCE     x   CREATE SEQUENCE scvdb.schedule_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE scvdb.schedule_sno_seq;
       scvdb          rnduser    false    6    225            "           0    0    schedule_sno_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE scvdb.schedule_sno_seq OWNED BY scvdb.schedule.sno;
          scvdb          rnduser    false    224            �            1259    17278    scvauditlogsseq    SEQUENCE     w   CREATE SEQUENCE scvdb.scvauditlogsseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE scvdb.scvauditlogsseq;
       scvdb          rnduser    false    6            �            1259    17279    scvauditlogs    TABLE       CREATE TABLE scvdb.scvauditlogs (
    id bigint DEFAULT nextval('scvdb.scvauditlogsseq'::regclass) NOT NULL,
    transactionid character varying(50),
    tasktype character varying(50),
    taskid character varying(50),
    taskname character varying(100),
    taskdescription character varying(500),
    vehicleid character varying(50),
    parentid character varying(50),
    direction character varying(20),
    executedtime bigint,
    expensetime integer,
    inputparam text,
    outputschema text,
    executionerror text
);
    DROP TABLE scvdb.scvauditlogs;
       scvdb         heap    rnduser    false    226    6            �            1259    17291    task    TABLE     �  CREATE TABLE scvdb.task (
    sno bigint NOT NULL,
    sender_id character varying(40) NOT NULL,
    sender text,
    input_value text,
    description character varying(50) NOT NULL,
    task_stml text,
    type character varying(50) DEFAULT 'restful'::character varying,
    alias character varying(100),
    direction character varying(20) DEFAULT 'Inbound'::character varying,
    name character varying(50),
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50),
    custom_type character varying(10),
    custom_key character varying(50)
);
    DROP TABLE scvdb.task;
       scvdb         heap    rnduser    false    6            #           0    0    COLUMN task.frst_rg_dt    COMMENT     A   COMMENT ON COLUMN scvdb.task.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    229            $           0    0    COLUMN task.frst_rg_id    COMMENT     >   COMMENT ON COLUMN scvdb.task.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    229            %           0    0    COLUMN task.last_md_dt    COMMENT     A   COMMENT ON COLUMN scvdb.task.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    229            &           0    0    COLUMN task.last_md_id    COMMENT     >   COMMENT ON COLUMN scvdb.task.last_md_id IS '최종수정자';
          scvdb          rnduser    false    229            '           0    0    COLUMN task.custom_type    COMMENT     E   COMMENT ON COLUMN scvdb.task.custom_type IS '사용자정의타입';
          scvdb          rnduser    false    229            (           0    0    COLUMN task.custom_key    COMMENT     A   COMMENT ON COLUMN scvdb.task.custom_key IS '사용자정의키';
          scvdb          rnduser    false    229            �            1259    17290    task_sno_seq    SEQUENCE     t   CREATE SEQUENCE scvdb.task_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE scvdb.task_sno_seq;
       scvdb          rnduser    false    6    229            )           0    0    task_sno_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE scvdb.task_sno_seq OWNED BY scvdb.task.sno;
          scvdb          rnduser    false    228            �            1259    17303 	   task_stat    TABLE       CREATE TABLE scvdb.task_stat (
    sno bigint NOT NULL,
    sender_id character varying(40) NOT NULL,
    description character varying(40) NOT NULL,
    vehicle_cnt integer,
    start_dt timestamp without time zone,
    end_dt timestamp without time zone,
    success_yn character varying(1),
    exec_cnt integer,
    success_cnt integer,
    fail_cnt integer,
    exec_time integer,
    transaction_id character varying(40),
    no_data_cnt integer,
    not_found_cnt integer,
    fail_log text,
    collect_dt character varying(10)
);
    DROP TABLE scvdb.task_stat;
       scvdb         heap    rnduser    false    6            *           0    0    COLUMN task_stat.sender_id    COMMENT     E   COMMENT ON COLUMN scvdb.task_stat.sender_id IS '작업지시서 ID';
          scvdb          rnduser    false    231            +           0    0    COLUMN task_stat.description    COMMENT     K   COMMENT ON COLUMN scvdb.task_stat.description IS '작업지시서 설명';
          scvdb          rnduser    false    231            ,           0    0    COLUMN task_stat.vehicle_cnt    COMMENT     R   COMMENT ON COLUMN scvdb.task_stat.vehicle_cnt IS '작업지시서내 Vehicle수';
          scvdb          rnduser    false    231            -           0    0    COLUMN task_stat.start_dt    COMMENT     >   COMMENT ON COLUMN scvdb.task_stat.start_dt IS '시작시간';
          scvdb          rnduser    false    231            .           0    0    COLUMN task_stat.end_dt    COMMENT     <   COMMENT ON COLUMN scvdb.task_stat.end_dt IS '종료시간';
          scvdb          rnduser    false    231            /           0    0    COLUMN task_stat.success_yn    COMMENT     `   COMMENT ON COLUMN scvdb.task_stat.success_yn IS '작업지시서(전체 Vehicle) 성공여부';
          scvdb          rnduser    false    231            0           0    0    COLUMN task_stat.exec_cnt    COMMENT     B   COMMENT ON COLUMN scvdb.task_stat.exec_cnt IS '수행Vehicle수';
          scvdb          rnduser    false    231            1           0    0    COLUMN task_stat.success_cnt    COMMENT     E   COMMENT ON COLUMN scvdb.task_stat.success_cnt IS '성공Vehicle수';
          scvdb          rnduser    false    231            2           0    0    COLUMN task_stat.fail_cnt    COMMENT     B   COMMENT ON COLUMN scvdb.task_stat.fail_cnt IS '실패Vehicle수';
          scvdb          rnduser    false    231            3           0    0    COLUMN task_stat.exec_time    COMMENT     ?   COMMENT ON COLUMN scvdb.task_stat.exec_time IS '수행시간';
          scvdb          rnduser    false    231            4           0    0    COLUMN task_stat.transaction_id    COMMENT     F   COMMENT ON COLUMN scvdb.task_stat.transaction_id IS '트랜잭션ID';
          scvdb          rnduser    false    231            5           0    0    COLUMN task_stat.no_data_cnt    COMMENT     E   COMMENT ON COLUMN scvdb.task_stat.no_data_cnt IS 'NoDataVehicle수';
          scvdb          rnduser    false    231            6           0    0    COLUMN task_stat.not_found_cnt    COMMENT     I   COMMENT ON COLUMN scvdb.task_stat.not_found_cnt IS 'NotFoundVehicle수';
          scvdb          rnduser    false    231            7           0    0    COLUMN task_stat.fail_log    COMMENT     >   COMMENT ON COLUMN scvdb.task_stat.fail_log IS '실패로그';
          scvdb          rnduser    false    231            8           0    0    COLUMN task_stat.collect_dt    COMMENT     @   COMMENT ON COLUMN scvdb.task_stat.collect_dt IS '수집일자';
          scvdb          rnduser    false    231            �            1259    17302    task_stat_sno_seq    SEQUENCE     y   CREATE SEQUENCE scvdb.task_stat_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE scvdb.task_stat_sno_seq;
       scvdb          rnduser    false    6    231            9           0    0    task_stat_sno_seq    SEQUENCE OWNED BY     E   ALTER SEQUENCE scvdb.task_stat_sno_seq OWNED BY scvdb.task_stat.sno;
          scvdb          rnduser    false    230            �            1259    17322    user_log    TABLE     4  CREATE TABLE scvdb.user_log (
    sno bigint NOT NULL,
    session_id character varying(50) NOT NULL,
    login_id character varying(50) NOT NULL,
    ip_addr character varying(50),
    login_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    logout_time timestamp without time zone
);
    DROP TABLE scvdb.user_log;
       scvdb         heap    rnduser    false    6            �            1259    17321    user_log_sno_seq    SEQUENCE     x   CREATE SEQUENCE scvdb.user_log_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE scvdb.user_log_sno_seq;
       scvdb          rnduser    false    235    6            :           0    0    user_log_sno_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE scvdb.user_log_sno_seq OWNED BY scvdb.user_log.sno;
          scvdb          rnduser    false    234            �            1259    17312    vehicle    TABLE     �  CREATE TABLE scvdb.vehicle (
    sno bigint NOT NULL,
    prj_code character varying(40) NOT NULL,
    vehicle_id character varying(40) NOT NULL,
    vehicle_name character varying(100),
    type character varying(20),
    tag character varying(30),
    direction character varying(10),
    vehicle_stml text,
    frst_rg_dt timestamp without time zone,
    frst_rg_id character varying(50),
    last_md_dt timestamp without time zone,
    last_md_id character varying(50)
);
    DROP TABLE scvdb.vehicle;
       scvdb         heap    rnduser    false    6            ;           0    0    COLUMN vehicle.frst_rg_dt    COMMENT     D   COMMENT ON COLUMN scvdb.vehicle.frst_rg_dt IS '최초등록일시';
          scvdb          rnduser    false    233            <           0    0    COLUMN vehicle.frst_rg_id    COMMENT     A   COMMENT ON COLUMN scvdb.vehicle.frst_rg_id IS '최초등록자';
          scvdb          rnduser    false    233            =           0    0    COLUMN vehicle.last_md_dt    COMMENT     D   COMMENT ON COLUMN scvdb.vehicle.last_md_dt IS '최종수정일시';
          scvdb          rnduser    false    233            >           0    0    COLUMN vehicle.last_md_id    COMMENT     A   COMMENT ON COLUMN scvdb.vehicle.last_md_id IS '최종수정자';
          scvdb          rnduser    false    233            �            1259    17311    vehicle_sno_seq    SEQUENCE     w   CREATE SEQUENCE scvdb.vehicle_sno_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE scvdb.vehicle_sno_seq;
       scvdb          rnduser    false    6    233            ?           0    0    vehicle_sno_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE scvdb.vehicle_sno_seq OWNED BY scvdb.vehicle.sno;
          scvdb          rnduser    false    232            v           2604    17226    configure sno    DEFAULT     l   ALTER TABLE ONLY scvdb.configure ALTER COLUMN sno SET DEFAULT nextval('scvdb.configure_sno_seq'::regclass);
 ;   ALTER TABLE scvdb.configure ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    216    217    217            �           2604    17333    gs_apt_trade apt_dling_rcptn_id    DEFAULT     �   ALTER TABLE ONLY scvdb.gs_apt_trade ALTER COLUMN apt_dling_rcptn_id SET DEFAULT nextval('scvdb.gs_apt_trade_apt_dling_rcptn_id_seq'::regclass);
 M   ALTER TABLE scvdb.gs_apt_trade ALTER COLUMN apt_dling_rcptn_id DROP DEFAULT;
       scvdb          rnduser    false    236    237    237            �           2604    17347 '   gs_eleccar_charge elctrc_auto_chgstn_id    DEFAULT     �   ALTER TABLE ONLY scvdb.gs_eleccar_charge ALTER COLUMN elctrc_auto_chgstn_id SET DEFAULT nextval('scvdb.gs_eleccar_charge_elctrc_auto_chgstn_id_seq'::regclass);
 U   ALTER TABLE scvdb.gs_eleccar_charge ALTER COLUMN elctrc_auto_chgstn_id DROP DEFAULT;
       scvdb          rnduser    false    239    238    239            �           2604    17360    gs_garden_rent garden_rent_id    DEFAULT     �   ALTER TABLE ONLY scvdb.gs_garden_rent ALTER COLUMN garden_rent_id SET DEFAULT nextval('scvdb.gs_garden_rent_garden_rent_id_seq'::regclass);
 K   ALTER TABLE scvdb.gs_garden_rent ALTER COLUMN garden_rent_id DROP DEFAULT;
       scvdb          rnduser    false    240    241    241            �           2604    17373    gs_policy_news plcy_news_id    DEFAULT     �   ALTER TABLE ONLY scvdb.gs_policy_news ALTER COLUMN plcy_news_id SET DEFAULT nextval('scvdb.gs_policy_news_plcy_news_id_seq'::regclass);
 I   ALTER TABLE scvdb.gs_policy_news ALTER COLUMN plcy_news_id DROP DEFAULT;
       scvdb          rnduser    false    242    243    243            �           2604    17386 "   gs_worknet_info gs_worknet_info_id    DEFAULT     �   ALTER TABLE ONLY scvdb.gs_worknet_info ALTER COLUMN gs_worknet_info_id SET DEFAULT nextval('scvdb.gs_worknet_info_gs_worknet_info_id_seq'::regclass);
 P   ALTER TABLE scvdb.gs_worknet_info ALTER COLUMN gs_worknet_info_id DROP DEFAULT;
       scvdb          rnduser    false    245    244    245            x           2604    17242    job_mapper_list sno    DEFAULT     x   ALTER TABLE ONLY scvdb.job_mapper_list ALTER COLUMN sno SET DEFAULT nextval('scvdb.job_mapper_list_sno_seq'::regclass);
 A   ALTER TABLE scvdb.job_mapper_list ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    220    219    220            |           2604    17252    member member_id    DEFAULT     r   ALTER TABLE ONLY scvdb.member ALTER COLUMN member_id SET DEFAULT nextval('scvdb.member_member_id_seq'::regclass);
 >   ALTER TABLE scvdb.member ALTER COLUMN member_id DROP DEFAULT;
       scvdb          rnduser    false    222    221    222            �           2604    17273    schedule sno    DEFAULT     j   ALTER TABLE ONLY scvdb.schedule ALTER COLUMN sno SET DEFAULT nextval('scvdb.schedule_sno_seq'::regclass);
 :   ALTER TABLE scvdb.schedule ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    225    224    225            �           2604    17294    task sno    DEFAULT     b   ALTER TABLE ONLY scvdb.task ALTER COLUMN sno SET DEFAULT nextval('scvdb.task_sno_seq'::regclass);
 6   ALTER TABLE scvdb.task ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    229    228    229            �           2604    17306    task_stat sno    DEFAULT     l   ALTER TABLE ONLY scvdb.task_stat ALTER COLUMN sno SET DEFAULT nextval('scvdb.task_stat_sno_seq'::regclass);
 ;   ALTER TABLE scvdb.task_stat ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    231    230    231            �           2604    17325    user_log sno    DEFAULT     j   ALTER TABLE ONLY scvdb.user_log ALTER COLUMN sno SET DEFAULT nextval('scvdb.user_log_sno_seq'::regclass);
 :   ALTER TABLE scvdb.user_log ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    235    234    235            �           2604    17315    vehicle sno    DEFAULT     h   ALTER TABLE ONLY scvdb.vehicle ALTER COLUMN sno SET DEFAULT nextval('scvdb.vehicle_sno_seq'::regclass);
 9   ALTER TABLE scvdb.vehicle ALTER COLUMN sno DROP DEFAULT;
       scvdb          rnduser    false    232    233    233            _          0    17223 	   configure 
   TABLE DATA           �   COPY scvdb.configure (sno, prj_code, conf_key, conf_value, description, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    217   PN      s          0    17330    gs_apt_trade 
   TABLE DATA           
  COPY scvdb.gs_apt_trade (apt_dling_rcptn_id, estate_adlng_tnthw_unit_amt, estate_actr_yr, estate_ctrt_yr, stdg_addr, apt_nm, estate_ctrt_mm, estate_ctrt_de, xuar, lotno_addr, stdg_cd, bldg_flr_cnt, frst_reg_dt, frst_rgtr_id, last_mdfcn_dt, last_mdfr_id) FROM stdin;
    scvdb          rnduser    false    237   mN      u          0    17344    gs_eleccar_charge 
   TABLE DATA           �  COPY scvdb.gs_eleccar_charge (elctrc_auto_chgstn_id, chgstn_nm, chgstn_id, chgr_id, chgr_typ, chgr_addr, chgr_addr_dtl_cn, lat, lot, utztn_psblty_hr, inst_id, inst_nm, oper_inst_nm, oper_inst_cttpc, chgr_stts, stts_updt_dt, lst_chg_bgng_dt, lst_chg_end_dt, chgng_bgng_dt, chg_cpct, chg_way, ctpv_cd, stdg_cd, chgstn_se_cd, chgstn_se_dtl_cd, prk_fee_free, chgstn_guide, user_lmt, utztn_lmt_rsn, del_yn, del_rsn, frst_reg_dt, frst_rgtr_id, last_mdfcn_dt, last_mdfr_id) FROM stdin;
    scvdb          rnduser    false    239   �N      w          0    17357    gs_garden_rent 
   TABLE DATA           \  COPY scvdb.gs_garden_rent (garden_rent_id, kcngdn_id, oper_inst_cd, kcngdn_nm, ctpv_cd, ctpv_nm, kcngdn_sgg_no, sgg_nm, kcngdn_slnlt_addr, kcngdn_whole_sfc, kcngdn_slnlt_sfc, hmpg_addr, rcrt_prd_cn, sbrs_cn, kcngdn_aply_mthd_cn, kcngdn_slnlt_prc_cn, lat, lot, reg_ymd, mdfcn_ymd, frst_reg_dt, frst_rgtr_id, last_mdfcn_dt, last_mdfr_id) FROM stdin;
    scvdb          rnduser    false    241   �N      y          0    17370    gs_policy_news 
   TABLE DATA           )  COPY scvdb.gs_policy_news (plcy_news_id, news_id, cns_stts, chg_cunt, chg_dt, aprv_dt, autzr_nm, embgo_rmv_dt, clsf_cd, ttl, sbttl1, sbttl2, sbttl3, news_cn_typ, news_cn, gvmdpt_nm, reduce_img_url, orgnl_img_url, news_orgnl_url, frst_reg_dt, frst_rgtr_id, last_mdfcn_dt, last_mdfr_id) FROM stdin;
    scvdb          rnduser    false    243   �N      {          0    17383    gs_worknet_info 
   TABLE DATA           �  COPY scvdb.gs_worknet_info (gs_worknet_info_id, stswnt_cert_no, co_nm, emplmt_nm, wgs_se_nm, salary_amt, min_salary_amt, max_salary_amt, work_rgn_addr, work_shap_se_nm, min_acbg_se_nm, max_acbg_se_nm, wkep_se_nm, reg_ymd, skjob_ddln_ymd, info_pvsn_nm, url_addr, plcwrk_zip, plcwrk_road_nm_addr, plcwrk_bass_addr, plcwrk_daddr, skjob_emplmt_shap_no, skjob_ocpt_no, frst_reg_dt, frst_rgtr_id, last_mdfcn_dt, last_mdfr_id) FROM stdin;
    scvdb          rnduser    false    245   �N      `          0    17232    job_list 
   TABLE DATA           �   COPY scvdb.job_list (sender_id, vehicle_id, collect_class, parent_id, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    218   �N      b          0    17239    job_mapper_list 
   TABLE DATA           �   COPY scvdb.job_mapper_list (sno, sender_id, input_param, column_mapper, merge_se, tab_name, delete_key, delete_option, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    220   O      d          0    17249    member 
   TABLE DATA           �   COPY scvdb.member (member_id, login_id, login_pwd, user_name, user_email, user_role, user_phone_number, profile_picture_url, account_non_locked, fail_count, lock_time, locked, fail_attempt, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    222   8O      e          0    17263    project 
   TABLE DATA           }   COPY scvdb.project (code, code_nm, up_code, description, del_yn, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    223   �O      g          0    17270    schedule 
   TABLE DATA           �   COPY scvdb.schedule (sno, sender_id, cron_text, sch_desc, sch_type, sch_exec, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    225   P      i          0    17279    scvauditlogs 
   TABLE DATA           �   COPY scvdb.scvauditlogs (id, transactionid, tasktype, taskid, taskname, taskdescription, vehicleid, parentid, direction, executedtime, expensetime, inputparam, outputschema, executionerror) FROM stdin;
    scvdb          rnduser    false    227   $P      k          0    17291    task 
   TABLE DATA           �   COPY scvdb.task (sno, sender_id, sender, input_value, description, task_stml, type, alias, direction, name, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id, custom_type, custom_key) FROM stdin;
    scvdb          rnduser    false    229   AP      m          0    17303 	   task_stat 
   TABLE DATA           �   COPY scvdb.task_stat (sno, sender_id, description, vehicle_cnt, start_dt, end_dt, success_yn, exec_cnt, success_cnt, fail_cnt, exec_time, transaction_id, no_data_cnt, not_found_cnt, fail_log, collect_dt) FROM stdin;
    scvdb          rnduser    false    231   ^P      q          0    17322    user_log 
   TABLE DATA           ^   COPY scvdb.user_log (sno, session_id, login_id, ip_addr, login_time, logout_time) FROM stdin;
    scvdb          rnduser    false    235   {P      o          0    17312    vehicle 
   TABLE DATA           �   COPY scvdb.vehicle (sno, prj_code, vehicle_id, vehicle_name, type, tag, direction, vehicle_stml, frst_rg_dt, frst_rg_id, last_md_dt, last_md_id) FROM stdin;
    scvdb          rnduser    false    233   �P      @           0    0    configure_sno_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('scvdb.configure_sno_seq', 1, false);
          scvdb          rnduser    false    216            A           0    0 #   gs_apt_trade_apt_dling_rcptn_id_seq    SEQUENCE SET     Q   SELECT pg_catalog.setval('scvdb.gs_apt_trade_apt_dling_rcptn_id_seq', 1, false);
          scvdb          rnduser    false    236            B           0    0 +   gs_eleccar_charge_elctrc_auto_chgstn_id_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('scvdb.gs_eleccar_charge_elctrc_auto_chgstn_id_seq', 1, false);
          scvdb          rnduser    false    238            C           0    0 !   gs_garden_rent_garden_rent_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('scvdb.gs_garden_rent_garden_rent_id_seq', 1, false);
          scvdb          rnduser    false    240            D           0    0    gs_policy_news_plcy_news_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('scvdb.gs_policy_news_plcy_news_id_seq', 1, false);
          scvdb          rnduser    false    242            E           0    0 &   gs_worknet_info_gs_worknet_info_id_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('scvdb.gs_worknet_info_gs_worknet_info_id_seq', 1, false);
          scvdb          rnduser    false    244            F           0    0    job_mapper_list_sno_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('scvdb.job_mapper_list_sno_seq', 1, false);
          scvdb          rnduser    false    219            G           0    0    member_member_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('scvdb.member_member_id_seq', 1, true);
          scvdb          rnduser    false    221            H           0    0    schedule_sno_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('scvdb.schedule_sno_seq', 1, false);
          scvdb          rnduser    false    224            I           0    0    scvauditlogsseq    SEQUENCE SET     =   SELECT pg_catalog.setval('scvdb.scvauditlogsseq', 1, false);
          scvdb          rnduser    false    226            J           0    0    task_sno_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('scvdb.task_sno_seq', 1, false);
          scvdb          rnduser    false    228            K           0    0    task_stat_sno_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('scvdb.task_stat_sno_seq', 1, false);
          scvdb          rnduser    false    230            L           0    0    user_log_sno_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('scvdb.user_log_sno_seq', 1, false);
          scvdb          rnduser    false    234            M           0    0    vehicle_sno_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('scvdb.vehicle_sno_seq', 1, false);
          scvdb          rnduser    false    232            �           2606    17230    configure configure_pk 
   CONSTRAINT     T   ALTER TABLE ONLY scvdb.configure
    ADD CONSTRAINT configure_pk PRIMARY KEY (sno);
 ?   ALTER TABLE ONLY scvdb.configure DROP CONSTRAINT configure_pk;
       scvdb            rnduser    false    217            �           2606    17341    gs_apt_trade gs_apt_trade_pkey 
   CONSTRAINT     k   ALTER TABLE ONLY scvdb.gs_apt_trade
    ADD CONSTRAINT gs_apt_trade_pkey PRIMARY KEY (apt_dling_rcptn_id);
 G   ALTER TABLE ONLY scvdb.gs_apt_trade DROP CONSTRAINT gs_apt_trade_pkey;
       scvdb            rnduser    false    237            �           2606    17355 &   gs_eleccar_charge gs_eleccar_charge_pk 
   CONSTRAINT     v   ALTER TABLE ONLY scvdb.gs_eleccar_charge
    ADD CONSTRAINT gs_eleccar_charge_pk PRIMARY KEY (elctrc_auto_chgstn_id);
 O   ALTER TABLE ONLY scvdb.gs_eleccar_charge DROP CONSTRAINT gs_eleccar_charge_pk;
       scvdb            rnduser    false    239            �           2606    17368     gs_garden_rent gs_garden_rent_pk 
   CONSTRAINT     i   ALTER TABLE ONLY scvdb.gs_garden_rent
    ADD CONSTRAINT gs_garden_rent_pk PRIMARY KEY (garden_rent_id);
 I   ALTER TABLE ONLY scvdb.gs_garden_rent DROP CONSTRAINT gs_garden_rent_pk;
       scvdb            rnduser    false    241            �           2606    17381     gs_policy_news gs_policy_news_PK 
   CONSTRAINT     i   ALTER TABLE ONLY scvdb.gs_policy_news
    ADD CONSTRAINT "gs_policy_news_PK" PRIMARY KEY (plcy_news_id);
 K   ALTER TABLE ONLY scvdb.gs_policy_news DROP CONSTRAINT "gs_policy_news_PK";
       scvdb            rnduser    false    243            �           2606    17394 "   gs_worknet_info gs_worknet_info_pk 
   CONSTRAINT     k   ALTER TABLE ONLY scvdb.gs_worknet_info
    ADD CONSTRAINT gs_worknet_info_pk PRIMARY KEY (stswnt_cert_no);
 K   ALTER TABLE ONLY scvdb.gs_worknet_info DROP CONSTRAINT gs_worknet_info_pk;
       scvdb            rnduser    false    245            �           2606    17237    job_list job_list_pk 
   CONSTRAINT     s   ALTER TABLE ONLY scvdb.job_list
    ADD CONSTRAINT job_list_pk PRIMARY KEY (sender_id, vehicle_id, collect_class);
 =   ALTER TABLE ONLY scvdb.job_list DROP CONSTRAINT job_list_pk;
       scvdb            rnduser    false    218    218    218            �           2606    17247 "   job_mapper_list job_mapper_list_pk 
   CONSTRAINT     `   ALTER TABLE ONLY scvdb.job_mapper_list
    ADD CONSTRAINT job_mapper_list_pk PRIMARY KEY (sno);
 K   ALTER TABLE ONLY scvdb.job_mapper_list DROP CONSTRAINT job_mapper_list_pk;
       scvdb            rnduser    false    220            �           2606    17260    member member_pk 
   CONSTRAINT     T   ALTER TABLE ONLY scvdb.member
    ADD CONSTRAINT member_pk PRIMARY KEY (member_id);
 9   ALTER TABLE ONLY scvdb.member DROP CONSTRAINT member_pk;
       scvdb            rnduser    false    222            �           2606    17268    project project_pk 
   CONSTRAINT     Q   ALTER TABLE ONLY scvdb.project
    ADD CONSTRAINT project_pk PRIMARY KEY (code);
 ;   ALTER TABLE ONLY scvdb.project DROP CONSTRAINT project_pk;
       scvdb            rnduser    false    223            �           2606    17276    schedule schedule_pk 
   CONSTRAINT     R   ALTER TABLE ONLY scvdb.schedule
    ADD CONSTRAINT schedule_pk PRIMARY KEY (sno);
 =   ALTER TABLE ONLY scvdb.schedule DROP CONSTRAINT schedule_pk;
       scvdb            rnduser    false    225            �           2606    17286    scvauditlogs scvauditlogs_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY scvdb.scvauditlogs
    ADD CONSTRAINT scvauditlogs_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY scvdb.scvauditlogs DROP CONSTRAINT scvauditlogs_pkey;
       scvdb            rnduser    false    227            �           2606    17300    task task_pk 
   CONSTRAINT     J   ALTER TABLE ONLY scvdb.task
    ADD CONSTRAINT task_pk PRIMARY KEY (sno);
 5   ALTER TABLE ONLY scvdb.task DROP CONSTRAINT task_pk;
       scvdb            rnduser    false    229            �           2606    17310    task_stat task_stat_pk 
   CONSTRAINT     T   ALTER TABLE ONLY scvdb.task_stat
    ADD CONSTRAINT task_stat_pk PRIMARY KEY (sno);
 ?   ALTER TABLE ONLY scvdb.task_stat DROP CONSTRAINT task_stat_pk;
       scvdb            rnduser    false    231            �           2606    17328    user_log user_log_pk 
   CONSTRAINT     R   ALTER TABLE ONLY scvdb.user_log
    ADD CONSTRAINT user_log_pk PRIMARY KEY (sno);
 =   ALTER TABLE ONLY scvdb.user_log DROP CONSTRAINT user_log_pk;
       scvdb            rnduser    false    235            �           2606    17319    vehicle vehicle_pk 
   CONSTRAINT     P   ALTER TABLE ONLY scvdb.vehicle
    ADD CONSTRAINT vehicle_pk PRIMARY KEY (sno);
 ;   ALTER TABLE ONLY scvdb.vehicle DROP CONSTRAINT vehicle_pk;
       scvdb            rnduser    false    233            �           1259    17231    configure_prj_code_idx    INDEX     `   CREATE UNIQUE INDEX configure_prj_code_idx ON scvdb.configure USING btree (prj_code, conf_key);
 )   DROP INDEX scvdb.configure_prj_code_idx;
       scvdb            rnduser    false    217    217            �           1259    17342    gs_apt_trade_estate_ctrt_idx    INDEX     n   CREATE INDEX gs_apt_trade_estate_ctrt_idx ON scvdb.gs_apt_trade USING btree (estate_ctrt_yr, estate_ctrt_mm);
 /   DROP INDEX scvdb.gs_apt_trade_estate_ctrt_idx;
       scvdb            rnduser    false    237    237            �           1259    17261    member_login_id_idx    INDEX     I   CREATE INDEX member_login_id_idx ON scvdb.member USING btree (login_id);
 &   DROP INDEX scvdb.member_login_id_idx;
       scvdb            rnduser    false    222            �           1259    17262    member_user_email_idx    INDEX     T   CREATE UNIQUE INDEX member_user_email_idx ON scvdb.member USING btree (user_email);
 (   DROP INDEX scvdb.member_user_email_idx;
       scvdb            rnduser    false    222            �           1259    17301    project_sender_id_idx    INDEX     Q   CREATE UNIQUE INDEX project_sender_id_idx ON scvdb.task USING btree (sender_id);
 (   DROP INDEX scvdb.project_sender_id_idx;
       scvdb            rnduser    false    229            �           1259    17320    project_vehicle_id_idx    INDEX     V   CREATE UNIQUE INDEX project_vehicle_id_idx ON scvdb.vehicle USING btree (vehicle_id);
 )   DROP INDEX scvdb.project_vehicle_id_idx;
       scvdb            rnduser    false    233            �           1259    17277    schedule_sender_id_idx    INDEX     V   CREATE UNIQUE INDEX schedule_sender_id_idx ON scvdb.schedule USING btree (sender_id);
 )   DROP INDEX scvdb.schedule_sender_id_idx;
       scvdb            rnduser    false    225            �           1259    17287    scvauditlogs_executedtime_idx    INDEX     b   CREATE INDEX scvauditlogs_executedtime_idx ON scvdb.scvauditlogs USING btree (executedtime DESC);
 0   DROP INDEX scvdb.scvauditlogs_executedtime_idx;
       scvdb            rnduser    false    227            �           1259    17288    scvauditlogs_taskid_idx    INDEX     \   CREATE INDEX scvauditlogs_taskid_idx ON scvdb.scvauditlogs USING btree (taskid, vehicleid);
 *   DROP INDEX scvdb.scvauditlogs_taskid_idx;
       scvdb            rnduser    false    227    227            �           1259    17289    scvauditlogs_transactionid_idx    INDEX     j   CREATE INDEX scvauditlogs_transactionid_idx ON scvdb.scvauditlogs USING btree (transactionid, vehicleid);
 1   DROP INDEX scvdb.scvauditlogs_transactionid_idx;
       scvdb            rnduser    false    227    227            _      x������ � �      s      x������ � �      u      x������ � �      w      x������ � �      y      x������ � �      {      x������ � �      `      x������ � �      b      x������ � �      d   �   x�3�LLMI,It�Pz��z�E����F�f�I�����ƦIF���Fi&�Ii��Ʀ@�4��4S3�d#CK�4Ӕ�D�dCcs3Ӵ��$K�$s�K��T���d�Ds�W[^/[�f�������;��z�這���A�1~ T�i �Ҡ\����� ��;�      e      x������ � �      g      x������ � �      i      x������ � �      k      x������ � �      m      x������ � �      q      x������ � �      o      x������ � �     
