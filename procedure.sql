/*==============================================================*/
/* DBMS name:      Microsoft SQL Server 2012                    */
/* Created on:     2015/6/24 15:19:50                           */
/*==============================================================*/


if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.BASE_ESTATE')
            and   name  = 'Index_estateserialno'
            and   indid > 0
            and   indid < 255)
   drop index dbo.BASE_ESTATE.Index_estateserialno
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.BASE_ESTATE')
            and   name  = 'index_belongtowns'
            and   indid > 0
            and   indid < 255)
   drop index dbo.BASE_ESTATE.index_belongtowns
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BASE_ESTATE')
            and   type = 'U')
   drop table dbo.BASE_ESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BASE_HOUSE')
            and   type = 'U')
   drop table dbo.BASE_HOUSE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BAS_BUSINESSATTACHMENT')
            and   type = 'U')
   drop table dbo.BAS_BUSINESSATTACHMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_BUILDER')
            and   type = 'U')
   drop table dbo.BUS_BUILDER
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.BUS_ESTATE')
            and   name  = 'index_estateid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.BUS_ESTATE.index_estateid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_ESTATE')
            and   type = 'U')
   drop table dbo.BUS_ESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_ESTATECHANGE')
            and   type = 'U')
   drop table dbo.BUS_ESTATECHANGE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_HOUSE')
            and   type = 'U')
   drop table dbo.BUS_HOUSE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_HOUSE_RENT')
            and   type = 'U')
   drop table dbo.BUS_HOUSE_RENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_LANDGAIN')
            and   type = 'U')
   drop table dbo.BUS_LANDGAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_LANDSTORE')
            and   type = 'U')
   drop table dbo.BUS_LANDSTORE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_LANDSTORESUB')
            and   type = 'U')
   drop table dbo.BUS_LANDSTORESUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_OWNERSHIPTRANSFER')
            and   type = 'U')
   drop table dbo.BUS_OWNERSHIPTRANSFER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_PAYMENT')
            and   type = 'U')
   drop table dbo.BUS_PAYMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_RENT')
            and   type = 'U')
   drop table dbo.BUS_RENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_RIGHTSTRANSFER')
            and   type = 'U')
   drop table dbo.BUS_RIGHTSTRANSFER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.BUS_TAXREDUCE')
            and   type = 'U')
   drop table dbo.BUS_TAXREDUCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_ATTACHMENT')
            and   type = 'U')
   drop table dbo.COD_ATTACHMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_BELONGTOCOUNTRYCODE')
            and   type = 'U')
   drop table dbo.COD_BELONGTOCOUNTRYCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_BUSINESS')
            and   type = 'U')
   drop table dbo.COD_BUSINESS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_CALLINGCODE')
            and   type = 'U')
   drop table dbo.COD_CALLINGCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_COMPARESTATE')
            and   type = 'U')
   drop table dbo.COD_COMPARESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_DERATEREASONCODE')
            and   type = 'U')
   drop table dbo.COD_DERATEREASONCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_DERATEREASONCODESUB')
            and   type = 'U')
   drop table dbo.COD_DERATEREASONCODESUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_DERATETYPECODE')
            and   type = 'U')
   drop table dbo.COD_DERATETYPECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_DISTRICT')
            and   type = 'U')
   drop table dbo.COD_DISTRICT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_ECONATURECODE')
            and   type = 'U')
   drop table dbo.COD_ECONATURECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDLEVELCODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDLEVELCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDSOURCECODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDSOURCECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDTRANSFERTYPE')
            and   type = 'U')
   drop table dbo.COD_GROUNDTRANSFERTYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDTYPECODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDTYPECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDUSECODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDUSECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDUSEKINDCODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDUSEKINDCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_GROUNDUSEMODCODE')
            and   type = 'U')
   drop table dbo.COD_GROUNDUSEMODCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_HOUSECERTIFICATETYPE')
            and   type = 'U')
   drop table dbo.COD_HOUSECERTIFICATETYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_HOUSESOURCECODE')
            and   type = 'U')
   drop table dbo.COD_HOUSESOURCECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_HOUSESTRCODE')
            and   type = 'U')
   drop table dbo.COD_HOUSESTRCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_HOUSEUSECODE')
            and   type = 'U')
   drop table dbo.COD_HOUSEUSECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_IMPOSEMODECODE')
            and   type = 'U')
   drop table dbo.COD_IMPOSEMODECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_LANDCERTIFICATETYPE')
            and   type = 'U')
   drop table dbo.COD_LANDCERTIFICATETYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_LOCATIONTYPE')
            and   type = 'U')
   drop table dbo.COD_LOCATIONTYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_PROPERTYPECODE')
            and   type = 'U')
   drop table dbo.COD_PROPERTYPECODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_STOREAPPROVETYPE')
            and   type = 'U')
   drop table dbo.COD_STOREAPPROVETYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXCODE')
            and   type = 'U')
   drop table dbo.COD_TAXCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXCOUNT')
            and   type = 'U')
   drop table dbo.COD_TAXCOUNT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXCOUTSUB')
            and   type = 'U')
   drop table dbo.COD_TAXCOUTSUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXEMPCODE')
            and   type = 'U')
   drop table dbo.COD_TAXEMPCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXEMPCODE_copy')
            and   type = 'U')
   drop table dbo.COD_TAXEMPCODE_copy
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXORGCODE')
            and   type = 'U')
   drop table dbo.COD_TAXORGCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COD_TAXPARAMETER')
            and   type = 'U')
   drop table dbo.COD_TAXPARAMETER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.COMM_ATTACHMENT')
            and   type = 'U')
   drop table dbo.COMM_ATTACHMENT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_CLEARLOG')
            and   type = 'U')
   drop table dbo.CORE_CLEARLOG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_ESTATE')
            and   type = 'U')
   drop table dbo.CORE_ESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_HOUSE')
            and   type = 'U')
   drop table dbo.CORE_HOUSE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.CORE_PAYTAX')
            and   name  = 'Index_taxcode'
            and   indid > 0
            and   indid < 255)
   drop index dbo.CORE_PAYTAX.Index_taxcode
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.CORE_PAYTAX')
            and   name  = 'Index_taxdate'
            and   indid > 0
            and   indid < 255)
   drop index dbo.CORE_PAYTAX.Index_taxdate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.CORE_PAYTAX')
            and   name  = 'Index_taxpayerid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.CORE_PAYTAX.Index_taxpayerid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_PAYTAX')
            and   type = 'U')
   drop table dbo.CORE_PAYTAX
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_TAXABILITY')
            and   type = 'U')
   drop table dbo.CORE_TAXABILITY
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.CORE_TAXABILITYSUB')
            and   type = 'U')
   drop table dbo.CORE_TAXABILITYSUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.DATAARRANGE_DATASOURCE')
            and   type = 'U')
   drop table dbo.DATAARRANGE_DATASOURCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.DATAARRANGE_DATASOURCESUB')
            and   type = 'U')
   drop table dbo.DATAARRANGE_DATASOURCESUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.DISTRICT')
            and   type = 'U')
   drop table dbo.DISTRICT
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.GROUND_LEASEINFO')
            and   type = 'U')
   drop table dbo.GROUND_LEASEINFO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_CONFIG')
            and   type = 'U')
   drop table dbo.IMPORT_CONFIG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_CONFIGFIELD')
            and   type = 'U')
   drop table dbo.IMPORT_CONFIGFIELD
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_CONFIGSUB')
            and   type = 'U')
   drop table dbo.IMPORT_CONFIGSUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_EMPLOYLAND')
            and   type = 'U')
   drop table dbo.IMPORT_EMPLOYLAND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_ESTATE')
            and   type = 'U')
   drop table dbo.IMPORT_ESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_EXCEL_CONFIG_MAIN')
            and   type = 'U')
   drop table dbo.IMPORT_EXCEL_CONFIG_MAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_EXCEL_CONFIG_SUB')
            and   type = 'U')
   drop table dbo.IMPORT_EXCEL_CONFIG_SUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_LANDSTORE')
            and   type = 'U')
   drop table dbo.IMPORT_LANDSTORE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_LANDSTORESUB')
            and   type = 'U')
   drop table dbo.IMPORT_LANDSTORESUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_LOG')
            and   type = 'U')
   drop table dbo.IMPORT_LOG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_MATETAXPAYER')
            and   type = 'U')
   drop table dbo.IMPORT_MATETAXPAYER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.IMPORT_SELLLAND')
            and   type = 'U')
   drop table dbo.IMPORT_SELLLAND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.INIT_COMPARGAIN')
            and   type = 'U')
   drop table dbo.INIT_COMPARGAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.INIT_COMPARGAINMAIN')
            and   type = 'U')
   drop table dbo.INIT_COMPARGAINMAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.INIT_EMPLOYLAND')
            and   type = 'U')
   drop table dbo.INIT_EMPLOYLAND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.INIT_ESTATE')
            and   type = 'U')
   drop table dbo.INIT_ESTATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.KEY_DISTRICTNUMBER')
            and   type = 'U')
   drop table dbo.KEY_DISTRICTNUMBER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.KEY_TABLEKEYVALUES')
            and   type = 'U')
   drop table dbo.KEY_TABLEKEYVALUES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.LEV_LEVYCALENDAR')
            and   type = 'U')
   drop table dbo.LEV_LEVYCALENDAR
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.LEV_LEVYDATETYPE')
            and   type = 'U')
   drop table dbo.LEV_LEVYDATETYPE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_LEVBILL_ACCDATEORG'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_LEVBILL_ACCDATEORG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_LEVBILL_MAKEDATEORG'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_LEVBILL_MAKEDATEORG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_LEVBILLCASHBANK_EMPCODE'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_LEVBILLCASHBANK_EMPCODE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_MAKEDATETIME'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_MAKEDATETIME
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_TAXTYPECODE_LEV'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_TAXTYPECODE_LEV
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'idx_cashsumno'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.idx_cashsumno
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_LEVBILL_BOOKNO'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_LEVBILL_BOOKNO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   name  = 'IDX_TaxPayerId'
            and   indid > 0
            and   indid < 255)
   drop index dbo.LEV_TAXBILLDETAILCASHBANK.IDX_TaxPayerId
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.LEV_TAXBILLDETAILCASHBANK')
            and   type = 'U')
   drop table dbo.LEV_TAXBILLDETAILCASHBANK
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.MAP_BELONGTOCOUNTRYTAXORGCODE')
            and   name  = 'IDX_BELONGTCOUNTRYMAPTAXORG'
            and   indid > 0
            and   indid < 255)
   drop index dbo.MAP_BELONGTOCOUNTRYTAXORGCODE.IDX_BELONGTCOUNTRYMAPTAXORG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.MAP_BELONGTOCOUNTRYTAXORGCODE')
            and   type = 'U')
   drop table dbo.MAP_BELONGTOCOUNTRYTAXORGCODE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.MAP_BELONGTOWNTOLEVELRATE')
            and   type = 'U')
   drop table dbo.MAP_BELONGTOWNTOLEVELRATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.MAP_HOUSETOGROUND')
            and   type = 'U')
   drop table dbo.MAP_HOUSETOGROUND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.MAP_OLDESTATEIDTONEWESTATEID')
            and   type = 'U')
   drop table dbo.MAP_OLDESTATEIDTONEWESTATEID
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.MAP_TAXCODELEVYDATETYPE')
            and   type = 'U')
   drop table dbo.MAP_TAXCODELEVYDATETYPE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.OTHER_WORKEVALUATE')
            and   type = 'U')
   drop table dbo.OTHER_WORKEVALUATE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.POL_GROUNDREGIST')
            and   type = 'U')
   drop table dbo.POL_GROUNDREGIST
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.POL_TAXRATE')
            and   type = 'U')
   drop table dbo.POL_TAXRATE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.PRM_REG_PARAMS')
            and   name  = 'IDX_REGPARAMS'
            and   indid > 0
            and   indid < 255)
   drop index dbo.PRM_REG_PARAMS.IDX_REGPARAMS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.PRM_REG_PARAMS')
            and   type = 'U')
   drop table dbo.PRM_REG_PARAMS
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_ORGDATE'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_ORGDATE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_TaxRegisterDateOrg'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_TaxRegisterDateOrg
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'idx_taxorgcode'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.idx_taxorgcode
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_TAXREGISTMAIN_TAXCERNO'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_TAXREGISTMAIN_TAXCERNO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_REGISTMAIN_NAME'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_REGISTMAIN_NAME
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_SUPORG'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_SUPORG
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXREGISTMAIN')
            and   name  = 'IDX_TaxRegisterDate'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXREGISTMAIN.IDX_TaxRegisterDate
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.REG_TAXREGISTMAIN')
            and   type = 'U')
   drop table dbo.REG_TAXREGISTMAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.REG_TAXREGISTSUB')
            and   type = 'U')
   drop table dbo.REG_TAXREGISTSUB
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXTYPEREGISTER')
            and   name  = 'IDX_TAXTYPEREGIST_ORGCODE'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXTYPEREGISTER.IDX_TAXTYPEREGIST_ORGCODE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXTYPEREGISTER')
            and   name  = 'IDX_TAXTYPEREGISTER_NO2'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXTYPEREGISTER.IDX_TAXTYPEREGISTER_NO2
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXTYPEREGISTER')
            and   name  = 'IDX_TAXPAYERID'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXTYPEREGISTER.IDX_TAXPAYERID
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.REG_TAXTYPEREGISTER')
            and   name  = 'IDX_TAXTYPEREGISTER'
            and   indid > 0
            and   indid < 255)
   drop index dbo.REG_TAXTYPEREGISTER.IDX_TAXTYPEREGISTER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.REG_TAXTYPEREGISTER')
            and   type = 'U')
   drop table dbo.REG_TAXTYPEREGISTER
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.RULE_TAXSOURCE')
            and   type = 'U')
   drop table dbo.RULE_TAXSOURCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.RULE_TAXSOURCESUB')
            and   type = 'U')
   drop table dbo.RULE_TAXSOURCESUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SAM_DATAAUTHCONFIG')
            and   type = 'U')
   drop table dbo.SAM_DATAAUTHCONFIG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_ALLCODE_MAIN')
            and   type = 'U')
   drop table dbo.SYSTEM_ALLCODE_MAIN
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_GROUP2RESOURCE')
            and   type = 'U')
   drop table dbo.SYSTEM_GROUP2RESOURCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_GROUP2ROLE')
            and   type = 'U')
   drop table dbo.SYSTEM_GROUP2ROLE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_RESOURCES')
            and   type = 'U')
   drop table dbo.SYSTEM_RESOURCES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_ROLE2RESOURCE')
            and   type = 'U')
   drop table dbo.SYSTEM_ROLE2RESOURCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_ROLES')
            and   type = 'U')
   drop table dbo.SYSTEM_ROLES
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USER2GROUP')
            and   type = 'U')
   drop table dbo.SYSTEM_USER2GROUP
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USER2RESOURCE')
            and   type = 'U')
   drop table dbo.SYSTEM_USER2RESOURCE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USER2ROLE')
            and   type = 'U')
   drop table dbo.SYSTEM_USER2ROLE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USER2ROLE_copy')
            and   type = 'U')
   drop table dbo.SYSTEM_USER2ROLE_copy
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USERGROUPS')
            and   type = 'U')
   drop table dbo.SYSTEM_USERGROUPS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.SYSTEM_USERS')
            and   type = 'U')
   drop table dbo.SYSTEM_USERS
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_ABNORMALOPERATION')
            and   type = 'U')
   drop table dbo.TAX_ABNORMALOPERATION
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_MODELDEFINE')
            and   type = 'U')
   drop table dbo.TAX_MODELDEFINE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_NOTICEINFO')
            and   type = 'U')
   drop table dbo.TAX_NOTICEINFO
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_DISPOABLE')
            and   name  = 'Index_taxpayerid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_DISPOABLE.Index_taxpayerid
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_DISPOABLE')
            and   name  = 'Index_estateid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_DISPOABLE.Index_estateid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_SOURCE_DISPOABLE')
            and   type = 'U')
   drop table dbo.TAX_SOURCE_DISPOABLE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_ESTATE')
            and   name  = 'landsource_businessnumber'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_ESTATE.landsource_businessnumber
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_ESTATE')
            and   name  = 'Index_taxdate'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_ESTATE.Index_taxdate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_ESTATE')
            and   name  = 'Index_taxpayerid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_ESTATE.Index_taxpayerid
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_ESTATE')
            and   name  = 'idx_estateid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_ESTATE.idx_estateid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_SOURCE_ESTATE')
            and   type = 'U')
   drop table dbo.TAX_SOURCE_ESTATE
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_SOURCE_HOUSE')
            and   name  = 'housesource_busnumber'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_SOURCE_HOUSE.housesource_busnumber
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_SOURCE_HOUSE')
            and   type = 'U')
   drop table dbo.TAX_SOURCE_HOUSE
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_SOURCE_PLOUGH')
            and   type = 'U')
   drop table dbo.TAX_SOURCE_PLOUGH
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_TAXABILITY')
            and   name  = 'sourceid_shouldtaxmain'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_TAXABILITY.sourceid_shouldtaxmain
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_TAXABILITY')
            and   type = 'U')
   drop table dbo.TAX_TAXABILITY
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_TAXABILITYSUB')
            and   name  = 'sourceid_shouldtaxsub'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_TAXABILITYSUB.sourceid_shouldtaxsub
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_TAXABILITYSUB')
            and   name  = 'Index_taxcode'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_TAXABILITYSUB.Index_taxcode
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_TAXABILITYSUB')
            and   name  = 'Index_taxdate'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_TAXABILITYSUB.Index_taxdate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.TAX_TAXABILITYSUB')
            and   name  = 'index_taxpayerid'
            and   indid > 0
            and   indid < 255)
   drop index dbo.TAX_TAXABILITYSUB.index_taxpayerid
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TAX_TAXABILITYSUB')
            and   type = 'U')
   drop table dbo.TAX_TAXABILITYSUB
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TEMP_CHURANG')
            and   type = 'U')
   drop table dbo.TEMP_CHURANG
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TEMP_PIFU')
            and   type = 'U')
   drop table dbo.TEMP_PIFU
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.TMP_GROUND')
            and   type = 'U')
   drop table dbo.TMP_GROUND
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.T_RULEINFO')
            and   type = 'U')
   drop table dbo.T_RULEINFO
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.finalcheck')
            and   type = 'U')
   drop table dbo.finalcheck
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.notfinalcheckestate')
            and   type = 'U')
   drop table dbo.notfinalcheckestate
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.pbcatcol')
            and   name  = 'pbcatcol_idx'
            and   indid > 0
            and   indid < 255)
   drop index dbo.pbcatcol.pbcatcol_idx
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.pbcatcol')
            and   type = 'U')
   drop table dbo.pbcatcol
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.pbcatedt')
            and   name  = 'pbcatedt_idx'
            and   indid > 0
            and   indid < 255)
   drop index dbo.pbcatedt.pbcatedt_idx
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.pbcatedt')
            and   type = 'U')
   drop table dbo.pbcatedt
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.pbcatfmt')
            and   name  = 'pbcatfmt_idx'
            and   indid > 0
            and   indid < 255)
   drop index dbo.pbcatfmt.pbcatfmt_idx
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.pbcatfmt')
            and   type = 'U')
   drop table dbo.pbcatfmt
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.pbcattbl')
            and   name  = 'pbcattbl_idx'
            and   indid > 0
            and   indid < 255)
   drop index dbo.pbcattbl.pbcattbl_idx
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.pbcattbl')
            and   type = 'U')
   drop table dbo.pbcattbl
go

if exists (select 1
            from  sysindexes
           where  id    = object_id('dbo.pbcatvld')
            and   name  = 'pbcatvld_idx'
            and   indid > 0
            and   indid < 255)
   drop index dbo.pbcatvld.pbcatvld_idx
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.pbcatvld')
            and   type = 'U')
   drop table dbo.pbcatvld
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.t')
            and   type = 'U')
   drop table dbo.t
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.t1')
            and   type = 'U')
   drop table dbo.t1
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.t2')
            and   type = 'U')
   drop table dbo.t2
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.tmp')
            and   type = 'U')
   drop table dbo.tmp
go

if exists (select 1
            from  sysobjects
           where  id = object_id('dbo.ttt')
            and   type = 'U')
   drop table dbo.ttt
go

drop schema dbo
go

drop user dbo
go

/*==============================================================*/
/* User: dbo                                                    */
/*==============================================================*/
execute sp_grantdbaccess dbo
go

/*==============================================================*/
/* User: dbo                                                    */
/*==============================================================*/
create schema dbo
go

/*==============================================================*/
/* Table: BASE_ESTATE                                           */
/*==============================================================*/
create table dbo.BASE_ESTATE (
   estateid             varchar(32)          not null,
   ploughid             varchar(32)          null,
   datatype             varchar(2)           not null,
   state                varchar(2)           not null,
   landsource           varchar(2)           not null,
   estateserialno       varchar(30)          not null,
   estateseriallayer    varchar(32)          null,
   layerid              varchar(32)          null,
   landstoreid          varchar(32)          null,
   landcertificatetype  varchar(2)           null,
   landcertificate      varchar(30)          null,
   pictureno            varchar(50)          null,
   landcertificatedate  datetime             null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         null,
   purpose              varchar(2)           null,
   datebegin            datetime             null,
   dateend              datetime             null,
   certificatetype      varchar(2)           null,
   certificateid        varchar(50)          null,
   locationtype         varchar(2)           not null,
   belongtowns          varchar(30)          not null,
   detailaddress        varchar(100)         not null,
   holddate             datetime             not null,
   landmoney            decimal(14,2)        not null,
   landarea             decimal(14,2)        null,
   taxarea              decimal(14,2)        not null,
   landunitprice        decimal(14,2)        null,
   taxrate              decimal(14,6)        not null,
   plotratio            decimal(14,2)        null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   valid                varchar(2)           not null,
   busid                varchar(32)          null,
   printcount           int                  null,
   shareestateid        varchar(32)          null,
   landtaxflag          varchar(2)           null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   transfertype         varchar(2)           null,
   constraint PK_BASE_ESTATE primary key (estateid)
)
go

/*==============================================================*/
/* Index: index_belongtowns                                     */
/*==============================================================*/
create index index_belongtowns on dbo.BASE_ESTATE (
belongtowns ASC
)
go

/*==============================================================*/
/* Index: Index_estateserialno                                  */
/*==============================================================*/
create index Index_estateserialno on dbo.BASE_ESTATE (
estateserialno ASC
)
go

/*==============================================================*/
/* Table: BASE_HOUSE                                            */
/*==============================================================*/
create table dbo.BASE_HOUSE (
   houseid              varchar(32)          not null,
   state                varchar(2)           not null,
   housetype            varchar(2)           not null,
   connectflag          varchar(2)           not null,
   ownflag              varchar(2)           not null,
   housesource          varchar(2)           not null,
   registrationnumber   varchar(20)          null,
   housecertificatetype varchar(2)           null,
   housecertificate     varchar(30)          null,
   housecertificatedate datetime             null,
   productionlevel      varchar(20)          null,
   buildingnumber       varchar(10)          null,
   housenumber          varchar(10)          null,
   housestructure       varchar(20)          null,
   sumplynumber         decimal(5)           null,
   plynumber            decimal(5)           null,
   designapplication    varchar(20)          null,
   housearea            decimal(14,2)        not null,
   natureofproperty     varchar(20)          null,
   buildingcost         decimal(14,2)        null,
   devicecost           decimal(14,2)        null,
   landprice            decimal(14,2)        null,
   housetaxoriginalvalue decimal(14,2)        null,
   housetax             decimal(14,2)        null,
   houseprice           decimal(14,2)        null,
   usedate              datetime             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         null,
   locationtype         varchar(2)           not null,
   detailaddress        varchar(100)         not null,
   belongtowns          varchar(30)          not null,
   plotratio            decimal(14,2)        null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          not null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   valid                varchar(2)           not null,
   purpose              varchar(2)           null,
   houseserialno        varchar(32)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   constraint PK_BASE_HOUSE primary key (houseid)
)
go

/*==============================================================*/
/* Table: BAS_BUSINESSATTACHMENT                                */
/*==============================================================*/
create table dbo.BAS_BUSINESSATTACHMENT (
   businessattachmentid varchar(32)          not null,
   businesscode         varchar(6)           not null,
   attachmentcode       varchar(6)           not null,
   isdefault            smallint             not null,
   constraint PK_BAS_BUSINESSATTACHMENT primary key (businessattachmentid)
)
go

/*==============================================================*/
/* Table: BUS_BUILDER                                           */
/*==============================================================*/
create table dbo.BUS_BUILDER (
   builderid            varchar(32)          not null,
   houseid              varchar(32)          not null,
   projectname          varchar(100)         null,
   buildername          varchar(60)          not null,
   buildertype          varchar(2)           not null,
   projecttype          varchar(2)           not null,
   buildermanagerorg    varchar(30)          null,
   istoissuelicense     varchar(2)           null,
   contractname         varchar(100)         null,
   contractid           varchar(30)          null,
   begindate            datetime             null,
   enddate              datetime             null,
   money                decimal(14,2)        not null,
   paymoney             decimal(14,2)        not null,
   linkperson           varchar(30)          null,
   linkway              varchar(50)          null,
   remark               varchar(100)         null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_BUS_BUILDER primary key (builderid)
)
go

/*==============================================================*/
/* Table: BUS_ESTATE                                            */
/*==============================================================*/
create table dbo.BUS_ESTATE (
   busid                varchar(32)          not null,
   state                varchar(2)           not null,
   businesstype         varchar(2)           null,
   estateid             varchar(32)          not null,
   lessorid             varchar(20)          null,
   lessortaxpayername   varchar(100)         null,
   lesseesid            varchar(20)          null,
   lesseestaxpayername  varchar(100)         null,
   purpose              varchar(2)           null,
   protocolnumber       varchar(30)          null,
   holddate             datetime             null,
   landarea             decimal(14,2)        not null,
   landtaxarea          decimal(14,2)        not null,
   landamount           decimal(14,2)        not null,
   norentuseflag        varchar(2)           null,
   transmoney           decimal(14,2)        null,
   limitbegin           datetime             not null,
   limitend             datetime             not null,
   remark               varchar(400)         null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          not null,
   parentbusinessnumber varchar(60)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   valid                varchar(2)           not null,
   optdate              datetime             null,
   printcount           int                  null,
   lessorcontact        varchar(20)          null,
   lessortel            varchar(20)          null,
   constraint PK_BUS_ESTATE primary key (busid)
)
go

/*==============================================================*/
/* Index: index_estateid                                        */
/*==============================================================*/
create index index_estateid on dbo.BUS_ESTATE (
estateid ASC
)
go

/*==============================================================*/
/* Table: BUS_ESTATECHANGE                                      */
/*==============================================================*/
create table dbo.BUS_ESTATECHANGE (
   changeid             varchar(32)          not null,
   estateid             varchar(32)          null,
   houseid              varchar(32)          not null,
   state                smallint             not null,
   datatype             smallint             not null,
   changetype           int                  not null,
   changedate           datetime             not null,
   plougharea           decimal(14,2)        not null,
   changeplougharea     decimal(14,2)        not null,
   landarea             decimal(14,2)        not null,
   changearea           decimal(14,2)        not null,
   changeareareason     varchar(50)          null,
   holddate             datetime             null,
   changeholddate       datetime             null,
   taxlandprice         decimal(14,2)        not null,
   changelandprice      decimal(14,2)        not null,
   policybasis          varchar(2)           null,
   houseoriginalvalue   decimal(14,2)        not null,
   housechangevalue     decimal(14,2)        not null,
   areaofstructure      decimal(14,2)        not null,
   changehousearea      decimal(14,2)        not null,
   plotratio            decimal(14,2)        not null,
   changeplotratio      decimal(14,2)        not null,
   parametercode        varchar(2)           not null,
   defaultvalue         varchar(30)          not null,
   changedefaultvalue   varchar(30)          not null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(10)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_BUS_ESTATECHANGE primary key (changeid)
)
go

/*==============================================================*/
/* Table: BUS_HOUSE                                             */
/*==============================================================*/
create table dbo.BUS_HOUSE (
   busid                varchar(32)          not null,
   state                varchar(2)           not null,
   businesstype         varchar(2)           not null,
   houseid              varchar(32)          not null,
   lessorid             varchar(20)          not null,
   lessortaxpayername   varchar(100)         null,
   lesseesid            varchar(20)          null,
   lesseestaxpayername  varchar(100)         null,
   purpose              varchar(2)           null,
   protocolnumber       varchar(30)          null,
   housearea            decimal(14,2)        not null,
   landtaxarea          decimal(14,2)        not null,
   houseamount          decimal(14,2)        not null,
   norentuseflag        varchar(2)           null,
   transmoney           decimal(14,2)        null,
   usedate              datetime             not null,
   limitbegin           datetime             null,
   limitend             datetime             null,
   remark               varchar(400)         null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          not null,
   parentbusinessnumber varchar(60)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   valid                varchar(2)           not null,
   printcount           int                  null,
   hireflag             varchar(2)           null,
   houseserialno        varchar(32)          null,
   lessorcontact        varchar(20)          null,
   lessortel            varchar(20)          null,
   constraint PK_BUS_HOUSE primary key (busid)
)
go

/*==============================================================*/
/* Table: BUS_HOUSE_RENT                                        */
/*==============================================================*/
create table dbo.BUS_HOUSE_RENT (
   houseid              varchar(32)          not null,
   recno                int                  not null,
   limitbegin           datetime             not null,
   limitend             datetime             not null,
   transmoney           decimal(14,2)        not null,
   holddate             datetime             not null,
   constraint PK_BUS_HOUSE_RENT primary key (houseid, recno)
)
go

/*==============================================================*/
/* Table: BUS_LANDGAIN                                          */
/*==============================================================*/
create table dbo.BUS_LANDGAIN (
   landgainid           varchar(32)          not null,
   estateid             varchar(32)          not null,
   datatype             smallint             not null,
   state                smallint             not null,
   sellid               varchar(30)          not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         not null,
   freetax              smallint             not null,
   contractdate         datetime             null,
   gaindate             datetime             null,
   contractnumber       varchar(30)          not null,
   estateserial         varchar(30)          not null,
   purpose              varchar(2)           not null,
   property             varchar(2)           not null,
   landcertificatetype  varchar(2)           null,
   landcertificate      varchar(30)          null,
   landcertificatedate  datetime             null,
   limitbegin           datetime             null,
   limitend             datetime             null,
   detailaddress        varchar(100)         not null,
   areatotal            decimal(14,2)        not null,
   areareduce           decimal(14,2)        not null,
   taxarea              decimal(14,2)        not null,
   inputperson          varchar(20)          null,
   inputdate            datetime             null,
   landprice            decimal(14,2)        not null,
   landmoney            decimal(14,2)        not null,
   checkperson          varchar(20)          null,
   checkdate            datetime             null,
   taxstate             smallint             not null,
   taxdate              datetime             null,
   taxprice             decimal(14,2)        not null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(10)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_BUS_LANDGAIN primary key (landgainid)
)
go

/*==============================================================*/
/* Table: BUS_LANDSTORE                                         */
/*==============================================================*/
create table dbo.BUS_LANDSTORE (
   landstoreid          varchar(32)          not null,
   state                smallint             not null,
   datatype             smallint             not null,
   approvetype          varchar(2)           not null,
   district             varchar(30)          not null,
   name                 varchar(100)         not null,
   taxpayer             varchar(20)          not null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         null,
   approvenumber        varchar(50)          null,
   approvenumbercity    varchar(50)          null,
   approvedate          datetime             not null,
   areatotal            decimal(14,2)        not null,
   areasell             decimal(14,2)        not null,
   areaplough           decimal(14,2)        not null,
   areaploughfreetax    decimal(14,2)        not null,
   areabuild            decimal(14,2)        not null,
   areauseless          decimal(14,2)        not null,
   areaploughtaxpay     decimal(14,2)        not null,
   areaploughtax        decimal(14,2)        not null,
   taxprice             decimal(14,2)        not null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   remark               smallint             null,
   businesscode         varchar(6)           not null,
   taxstate             smallint             not null,
   taxdate              datetime             null,
   businessnumber       varchar(10)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   approvenumberlevel   varchar(2)           null,
   constraint PK_BUS_LANDSTORE primary key (landstoreid)
)
go

/*==============================================================*/
/* Table: BUS_LANDSTORESUB                                      */
/*==============================================================*/
create table dbo.BUS_LANDSTORESUB (
   landstorsubid        varchar(32)          not null,
   landstoreid          varchar(32)          not null,
   location             varchar(50)          not null,
   detailaddress        varchar(100)         not null,
   areatotal            decimal(14,2)        not null,
   areaplough           decimal(14,2)        not null,
   areabuild            decimal(14,2)        not null,
   areauseless          decimal(14,2)        not null,
   areasell             decimal(14,2)        not null,
   constraint PK_BUS_LANDSTORESUB primary key (landstorsubid)
)
go

/*==============================================================*/
/* Table: BUS_OWNERSHIPTRANSFER                                 */
/*==============================================================*/
create table dbo.BUS_OWNERSHIPTRANSFER (
   ownerid              varchar(32)          not null,
   estateid             varchar(32)          not null,
   houseid              varchar(32)          null,
   datatype             smallint             not null,
   businesscode         varchar(6)           not null,
   state                smallint             not null,
   agreementnumber      varchar(30)          null,
   lessorid             varchar(30)          not null,
   lessortaxpayername   varchar(100)         not null,
   lesseesid            varchar(30)          not null,
   lesseestaxpayername  varchar(100)         null,
   freetax              smallint             not null,
   landtaxpayer         smallint             not null,
   taxarea              decimal(14,2)        not null,
   transbegindate       datetime             null,
   transenddate         datetime             null,
   transmonthmoney      decimal(14,2)        not null,
   transmoney           decimal(14,2)        not null,
   landarea             decimal(14,2)        not null,
   housearea            decimal(14,2)        not null,
   landcertificatetype  varchar(2)           null,
   landcertificate      varchar(30)          null,
   landcertificatedate  datetime             null,
   purpose              varchar(2)           not null,
   limitbegin           datetime             null,
   limitend             datetime             null,
   inputperson          varchar(20)          null,
   inputdate            datetime             null,
   checkperson          varchar(20)          null,
   checkdate            datetime             null,
   taxstate             smallint             not null,
   taxdate              datetime             null,
   taxprice             decimal(14,2)        not null,
   businessnumber       varchar(10)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   norentuseflag        varchar(2)           null,
   fromestateid         varchar(32)          null,
   fromhouseid          varchar(32)          null,
   constraint PK_BUS_OWNERSHIPTRANSFER primary key (ownerid)
)
go

/*==============================================================*/
/* Table: BUS_PAYMENT                                           */
/*==============================================================*/
create table dbo.BUS_PAYMENT (
   paymentid            varchar(32)          not null,
   houseid              varchar(32)          not null,
   builderid            varchar(32)          not null,
   date                 datetime             not null,
   state                smallint             not null,
   paymoney             decimal(14,2)        not null,
   getticket            smallint             not null,
   billdate             datetime             null,
   belonglocal          smallint             not null,
   revenue              varchar(50)          not null,
   taxscale             decimal(14,2)        not null,
   remark               varchar(100)         null,
   businessnumber       varchar(10)          not null,
   businesscode         varchar(6)           not null,
   taxstate             smallint             not null,
   taxdate              datetime             null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_BUS_PAYMENT primary key (paymentid)
)
go

/*==============================================================*/
/* Table: BUS_RENT                                              */
/*==============================================================*/
create table dbo.BUS_RENT (
   estateid             varchar(32)          not null,
   recno                int                  not null,
   limitbegin           datetime             not null,
   limitend             datetime             not null,
   transmoney           decimal(14,2)        not null,
   holddate             datetime             not null,
   constraint PK_BUS_RENT primary key (estateid, recno)
)
go

/*==============================================================*/
/* Table: BUS_RIGHTSTRANSFER                                    */
/*==============================================================*/
create table dbo.BUS_RIGHTSTRANSFER (
   rightsid             varchar(32)          not null,
   houseid              varchar(32)          null,
   estateid             varchar(32)          not null,
   state                smallint             not null,
   datatype             smallint             not null,
   agreementnumber      varchar(30)          null,
   lessorid             varchar(30)          not null,
   lessortaxpayname     varchar(20)          not null,
   lesseesid            varchar(30)          not null,
   lesseestaxpayername  varchar(100)         not null,
   freetax              smallint             not null,
   transbegindate       datetime             null,
   transenddate         datetime             null,
   transyearmoney       decimal(14,2)        not null,
   transmonthmoney      decimal(14,2)        not null,
   transarea            decimal(14,2)        not null,
   landtaxpayer         smallint             not null,
   taxarea              decimal(14,2)        not null,
   taxprice             decimal(14,2)        not null,
   inputperson          varchar(20)          null,
   inputdate            datetime             null,
   checkperson          varchar(20)          null,
   checkdate            datetime             null,
   businessnumber       varchar(10)          not null,
   businesscode         varchar(6)           not null,
   taxstate             smallint             not null,
   taxdate              datetime             null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_BUS_RIGHTSTRANSFER primary key (rightsid)
)
go

/*==============================================================*/
/* Table: BUS_TAXREDUCE                                         */
/*==============================================================*/
create table dbo.BUS_TAXREDUCE (
   taxreduceid          varchar(32)          not null,
   estateid             varchar(32)          not null,
   state                smallint             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   taxcode              varchar(6)           not null,
   reducebegindate      datetime             not null,
   reduceenddate        datetime             not null,
   approvenumber        varchar(30)          not null,
   approveunit          varchar(50)          not null,
   reduceclass          varchar(2)           not null,
   reducenum            decimal(14,2)        not null,
   reducereason         varchar(100)         not null,
   policybasis          varchar(100)         not null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(10)          not null,
   businessid           varchar(32)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   datatype             varchar(2)           null,
   reducerate           decimal(14,6)        null,
   reduceamount         decimal(14,2)        null,
   constraint PK_BUS_TAXREDUCE primary key (taxreduceid)
)
go

/*==============================================================*/
/* Table: COD_ATTACHMENT                                        */
/*==============================================================*/
create table dbo.COD_ATTACHMENT (
   attachmentcode       varchar(6)           not null,
   attachmentname       varchar(50)          not null,
   node                 varchar(2)           not null,
   valid                varchar(2)           not null,
   constraint PK_COD_ATTACHMENT primary key (attachmentcode)
)
go

/*==============================================================*/
/* Table: COD_BELONGTOCOUNTRYCODE                               */
/*==============================================================*/
create table dbo.COD_BELONGTOCOUNTRYCODE (
   belongtocountrycode  varchar(10)          not null,
   belongtocountryname  varchar(40)          not null,
   valid                char(2)              not null,
   constraint PK_COD_BELONGTOCOUNTRYCODE primary key (belongtocountrycode)
)
go

/*==============================================================*/
/* Table: COD_BUSINESS                                          */
/*==============================================================*/
create table dbo.COD_BUSINESS (
   businesscode         varchar(6)           not null,
   businessname         varchar(30)          not null,
   businesstype         smallint             not null,
   prefix               varchar(2)           not null,
   identitykey          int                  not null,
   constraint PK_COD_BUSINESS primary key (businesscode)
)
go

/*==============================================================*/
/* Table: COD_CALLINGCODE                                       */
/*==============================================================*/
create table dbo.COD_CALLINGCODE (
   callingcode          varchar(10)          not null,
   callingname          varchar(50)          not null,
   node                 char(2)              not null,
   valid                char(2)              not null,
   constraint PK_COD_CALLINGCODE primary key nonclustered (callingcode)
)
go

/*==============================================================*/
/* Table: COD_COMPARESTATE                                      */
/*==============================================================*/
create table dbo.COD_COMPARESTATE (
   comparestatecode     varchar(2)           not null,
   comparestatename     varchar(20)          not null,
   constraint PK_COD_COMPARESTATE primary key (comparestatecode)
)
go

/*==============================================================*/
/* Table: COD_DERATEREASONCODE                                  */
/*==============================================================*/
create table dbo.COD_DERATEREASONCODE (
   deratereasoncode     varchar(2)           not null,
   deratereasonname     varchar(60)          not null,
   constraint PK_COD_DERATEREASONCODE primary key (deratereasoncode)
)
go

/*==============================================================*/
/* Table: COD_DERATEREASONCODESUB                               */
/*==============================================================*/
create table dbo.COD_DERATEREASONCODESUB (
   deratereasonsubcode  varchar(4)           not null,
   deratereasonsubname  varchar(60)          not null,
   valid                varchar(2)           not null,
   constraint PK_COD_DERATEREASONCODESUB primary key (deratereasonsubcode)
)
go

/*==============================================================*/
/* Table: COD_DERATETYPECODE                                    */
/*==============================================================*/
create table dbo.COD_DERATETYPECODE (
   deratetypecode       varchar(2)           not null,
   deratetypename       varchar(60)          not null,
   constraint PK_COD_DERATETYPECODE primary key (deratetypecode)
)
go

/*==============================================================*/
/* Table: COD_DISTRICT                                          */
/*==============================================================*/
create table dbo.COD_DISTRICT (
   id                   varchar(32)          not null,
   name                 varchar(64)          not null,
   parentid             varchar(32)          null,
   description          varchar(256)         null,
   levels               int                  not null,
   isdetail             int                  not null,
   name_png             varchar(64)          null,
   parentname           varchar(64)          null,
   orgid                int                  not null,
   constraint PK_DISTRICT primary key (id)
)
go

/*==============================================================*/
/* Table: COD_ECONATURECODE                                     */
/*==============================================================*/
create table dbo.COD_ECONATURECODE (
   econaturecode        varchar(6)           not null,
   econaturename        varchar(50)          not null,
   node                 char(2)              not null,
   valid                char(2)              not null,
   constraint PK_COD_ECONATURECODE primary key (econaturecode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDLEVELCODE                                   */
/*==============================================================*/
create table dbo.COD_GROUNDLEVELCODE (
   groundlevelcode      varchar(10)          not null,
   groundlevelname      varchar(100)         not null,
   rate                 decimal(14,2)        not null,
   taxorgcode           varchar(11)          not null,
   constraint PK_COD_GROUNDLEVELCODE primary key (groundlevelcode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDSOURCECODE                                  */
/*==============================================================*/
create table dbo.COD_GROUNDSOURCECODE (
   groundsourcecode     char(2)              not null,
   groundsourcename     varchar(100)         not null,
   constraint PK_COD_GROUNDSOURCECODE primary key (groundsourcecode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDTRANSFERTYPE                                */
/*==============================================================*/
create table dbo.COD_GROUNDTRANSFERTYPE (
   transfertypecode     varchar(2)           not null,
   transfertypename     varchar(100)         not null,
   valid                varchar(2)           not null,
   constraint PK_COD_GROUNDTRANSFERTYPE primary key (transfertypecode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDTYPECODE                                    */
/*==============================================================*/
create table dbo.COD_GROUNDTYPECODE (
   groundtypecode       char(2)              not null,
   groundtypename       varchar(60)          not null,
   constraint PK_COD_GROUNDTYPECODE primary key (groundtypecode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDUSECODE                                     */
/*==============================================================*/
create table dbo.COD_GROUNDUSECODE (
   groundusecode        char(2)              not null,
   groundusename        varchar(60)          not null,
   constraint PK_COD_GROUNDUSECODE primary key (groundusecode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDUSEKINDCODE                                 */
/*==============================================================*/
create table dbo.COD_GROUNDUSEKINDCODE (
   groundusekindcode    char(2)              not null,
   groundusekindname    varchar(60)          not null,
   constraint PK_COD_GROUNDUSEKINDCODE primary key (groundusekindcode)
)
go

/*==============================================================*/
/* Table: COD_GROUNDUSEMODCODE                                  */
/*==============================================================*/
create table dbo.COD_GROUNDUSEMODCODE (
   groundusemodecode    char(2)              not null,
   groundusemodecame    varchar(60)          not null,
   constraint PK_COD_GROUNDUSEMODCODE primary key (groundusemodecode)
)
go

/*==============================================================*/
/* Table: COD_HOUSECERTIFICATETYPE                              */
/*==============================================================*/
create table dbo.COD_HOUSECERTIFICATETYPE (
   housecertificatetypecode varchar(2)           not null,
   housecertificatetypename varchar(100)         not null,
   valid                varchar(2)           not null,
   constraint PK_COD_HOUSECERTIFICATETYPE primary key (housecertificatetypecode)
)
go

/*==============================================================*/
/* Table: COD_HOUSESOURCECODE                                   */
/*==============================================================*/
create table dbo.COD_HOUSESOURCECODE (
   housesourcecode      varchar(2)           not null,
   housesourcename      varchar(100)         not null,
   constraint PK_COD_HOUSESOURCECODE primary key (housesourcecode)
)
go

/*==============================================================*/
/* Table: COD_HOUSESTRCODE                                      */
/*==============================================================*/
create table dbo.COD_HOUSESTRCODE (
   housestrcode         varchar(2)           not null,
   housestrname         varchar(100)         not null,
   constraint PK_COD_HOUSESTRCODE primary key (housestrcode)
)
go

/*==============================================================*/
/* Table: COD_HOUSEUSECODE                                      */
/*==============================================================*/
create table dbo.COD_HOUSEUSECODE (
   houseusecode         varchar(2)           not null,
   houseusename         varchar(100)         not null,
   constraint PK_COD_HOUSEUSECODE primary key (houseusecode)
)
go

/*==============================================================*/
/* Table: COD_IMPOSEMODECODE                                    */
/*==============================================================*/
create table dbo.COD_IMPOSEMODECODE (
   imposemodecode       varchar(2)           not null,
   imposemodename       varchar(20)          not null,
   imposemodemapcode    varchar(2)           not null,
   valid                char(2)              not null,
   constraint PK_COD_IMPOSEMODECODE primary key (imposemodecode)
)
go

/*==============================================================*/
/* Table: COD_LANDCERTIFICATETYPE                               */
/*==============================================================*/
create table dbo.COD_LANDCERTIFICATETYPE (
   landcertificatetypecode varchar(2)           not null,
   landcertificatetypename varchar(20)          not null,
   valid                varchar(2)           null,
   constraint PK_COD_LANDCERTIFICATETYPE primary key (landcertificatetypecode)
)
go

/*==============================================================*/
/* Table: COD_LOCATIONTYPE                                      */
/*==============================================================*/
create table dbo.COD_LOCATIONTYPE (
   locationtypecode     varchar(2)           not null,
   locationtypename     varchar(100)         not null,
   valid                varchar(2)           not null,
   taxcode              varchar(6)           null,
   constraint PK_COD_LOCATIONTYPE primary key (locationtypecode)
)
go

/*==============================================================*/
/* Table: COD_PROPERTYPECODE                                    */
/*==============================================================*/
create table dbo.COD_PROPERTYPECODE (
   propertypecode       varchar(8)           not null,
   propertypename       varchar(20)          not null,
   valid                varchar(2)           not null,
   constraint PK_COD_PROPERTYPECODE primary key (propertypecode)
)
go

/*==============================================================*/
/* Table: COD_STOREAPPROVETYPE                                  */
/*==============================================================*/
create table dbo.COD_STOREAPPROVETYPE (
   approvetypecode      varchar(2)           not null,
   approvetypename      varchar(60)          not null,
   constraint PK_COD_GROUNDUSECODE primary key (approvetypecode)
)
go

/*==============================================================*/
/* Table: COD_TAXCODE                                           */
/*==============================================================*/
create table dbo.COD_TAXCODE (
   taxcode              varchar(6)           not null,
   taxname              varchar(50)          not null,
   taxnameshort         varchar(50)          null,
   taxingmode           char(2)              not null,
   useflag              char(2)              not null,
   taxcategorycode      char(2)              not null,
   rateflag             char(2)              not null,
   constraint PK_TAXCODE primary key (taxcode)
)
go

/*==============================================================*/
/* Table: COD_TAXCOUNT                                          */
/*==============================================================*/
create table dbo.COD_TAXCOUNT (
   taxcountcode         varchar(2)           not null,
   taxcountname         varchar(30)          not null,
   taxcode              varchar(6)           not null,
   formula              varchar(500)         not null,
   onlyonce             smallint             not null,
   constraint PK_COD_TAXCOUNT primary key (taxcountcode)
)
go

/*==============================================================*/
/* Table: COD_TAXCOUTSUB                                        */
/*==============================================================*/
create table dbo.COD_TAXCOUTSUB (
   taxcountsubcode      varchar(2)           not null,
   taxcountcode         varchar(30)          not null,
   parametername        varchar(30)          not null,
   constraint PK_COD_TAXCOUTSUB primary key (taxcountsubcode)
)
go

/*==============================================================*/
/* Table: COD_TAXEMPCODE                                        */
/*==============================================================*/
create table dbo.COD_TAXEMPCODE (
   taxempcode           varchar(20)          not null,
   taxorgcode           varchar(11)          not null,
   logincode            varchar(50)          not null,
   taxempname           varchar(20)          not null,
   password             varchar(50)          not null,
   leaderflag           varchar(2)           not null,
   levyflag             varchar(2)           not null,
   taxmanageflag        varchar(2)           not null,
   mgauth               varchar(4)           null,
   levyauth             varchar(4)           null,
   mgdropauth           varchar(4)           null,
   levydropauth         varchar(4)           null,
   authflag             varchar(2)           not null,
   valid                varchar(2)           not null,
   postname             varchar(100)         null,
   constraint taxempcode primary key nonclustered (taxempcode)
)
go

/*==============================================================*/
/* Table: COD_TAXEMPCODE_copy                                   */
/*==============================================================*/
create table dbo.COD_TAXEMPCODE_copy (
   taxempcode           varchar(20)          not null,
   taxorgcode           varchar(11)          not null,
   logincode            varchar(50)          not null,
   taxempname           varchar(20)          not null,
   password             varchar(50)          not null,
   leaderflag           varchar(2)           not null,
   levyflag             varchar(2)           not null,
   taxmanageflag        varchar(2)           not null,
   mgauth               varchar(4)           null,
   levyauth             varchar(4)           null,
   mgdropauth           varchar(4)           null,
   levydropauth         varchar(4)           null,
   authflag             varchar(2)           not null,
   valid                varchar(2)           not null,
   postname             varchar(100)         null,
   constraint COD_TAXEMPCODE_x primary key nonclustered (taxempcode)
)
go

/*==============================================================*/
/* Table: COD_TAXORGCODE                                        */
/*==============================================================*/
create table dbo.COD_TAXORGCODE (
   taxorgcode           varchar(11)          not null,
   taxorgname           varchar(40)          not null,
   taxorgshortname      varchar(30)          not null,
   parentId             varchar(11)          not null,
   rootnode             varchar(2)           not null,
   mgauth               varchar(4)           null,
   levyauth             varchar(4)           null,
   mgdropauth           varchar(4)           null,
   levydropauth         varchar(4)           null,
   orgclass             varchar(2)           not null,
   orgtype              varchar(2)           not null,
   valid                varchar(2)           not null,
   levelNum             int                  null,
   childrenNum          int                  null,
   hierarchy            varchar(100)         null,
   constraint taxorgcode primary key nonclustered (taxorgcode)
)
go

/*==============================================================*/
/* Table: COD_TAXPARAMETER                                      */
/*==============================================================*/
create table dbo.COD_TAXPARAMETER (
   parametercode        varchar(2)           not null,
   parametername        varchar(30)          not null,
   parametertype        smallint             not null,
   gettype              smallint             not null,
   defaultvalue         varchar(30)          not null,
   iscount              smallint             not null,
   constraint PK_COD_TAXPARAMETER primary key (parametercode)
)
go

/*==============================================================*/
/* Table: COMM_ATTACHMENT                                       */
/*==============================================================*/
create table dbo.COMM_ATTACHMENT (
   attachmentid         varchar(32)          not null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(10)          not null,
   attachmentname       varchar(50)          not null,
   attachmentcode       varchar(6)           not null,
   filesize             decimal(16,2)        not null,
   address              varchar(100)         not null,
   uploaddate           datetime             not null,
   inputperson          varchar(20)          not null,
   isdefault            varchar(2)           not null,
   attachmenttypename   varchar(100)         null,
   usercode             varchar(32)          null,
   constraint pk_attachmentid primary key nonclustered (attachmentid)
)
go

/*==============================================================*/
/* Table: CORE_CLEARLOG                                         */
/*==============================================================*/
create table dbo.CORE_CLEARLOG (
   clearlogid           varchar(32)          not null,
   cleardate            datetime             not null,
   clearyear            smallint             not null,
   clearmonth           smallint             not null,
   cleartype            smallint             not null,
   clearperson          varchar(20)          not null,
   state                smallint             not null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   owingtax             smallint             null,
   differencetax        smallint             null,
   settletax            smallint             null,
   taxsourcesdifference smallint             null,
   manualowingtax       smallint             null,
   manualsettletax      smallint             null,
   manualtaxsourcesdifference smallint             null,
   constraint PK_CORE_CLEARLOG primary key (clearlogid)
)
go

/*==============================================================*/
/* Table: CORE_ESTATE                                           */
/*==============================================================*/
create table dbo.CORE_ESTATE (
   estateid             varchar(32)          not null,
   state                smallint             not null,
   estatetype           smallint             not null,
   selfnumber           varchar(30)          not null,
   estateserial         varchar(30)          null,
   estateseriallayer    varchar(30)          null,
   layerid              varchar(32)          null,
   landcertificatetype  varchar(2)           null,
   landcertificate      varchar(30)          null,
   landcertificatedate  datetime             null,
   landsource           varchar(2)           not null,
   protocolnumber       varchar(30)          null,
   holddate             datetime             not null,
   landtaxprice         decimal(14,2)        not null,
   taxperiod            varchar(2)           not null,
   landareaapprovalunit varchar(50)          null,
   landareaapprovaldate datetime             null,
   limitbegin           datetime             null,
   limitend             datetime             null,
   locationtype         varchar(2)           not null,
   belongtowns          varchar(30)          not null,
   detailaddress        varchar(100)         not null,
   landarea             decimal(14,2)        not null,
   taxfreearea          decimal(14,2)        not null,
   reducearea           decimal(14,2)        not null,
   hirelandarea         decimal(14,2)        not null,
   hirelandreducearea   decimal(14,2)        not null,
   hirehousesreducearea decimal(14,2)        not null,
   taxarea              decimal(14,2)        not null,
   plougharea           decimal(14,2)        not null,
   ploughfreearea       decimal(14,2)        not null,
   ploughreducearea     decimal(14,2)        not null,
   ploughtaxarea        decimal(14,2)        not null,
   landvaluecount       smallint             not null,
   landprice            decimal(14,2)        not null,
   landmoney            decimal(14,2)        not null,
   houselandmoney       decimal(14,2)        not null,
   landsellcost         decimal(14,2)        not null,
   landploughtaxcost    decimal(14,2)        not null,
   landcontracttaxcost  decimal(14,2)        not null,
   landdevelopcost      decimal(14,2)        not null,
   landelsecost         decimal(14,2)        not null,
   plotratio            decimal(14,2)        not null,
   areaofstructure      decimal(14,2)        not null,
   houseoriginalvalue   decimal(14,2)        not null,
   househirereducevalue decimal(14,2)        not null,
   housechangevalue     decimal(14,2)        not null,
   housefreevalue       decimal(14,2)        not null,
   housetaxoriginalvalue decimal(14,2)        not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   fromestateid         varchar(32)          null,
   treeid               varchar(50)          not null,
   treeparentid         varchar(50)          not null,
   isnode               smallint             not null,
   treelevel            smallint             not null,
   businessid           varchar(32)          null,
   businesscode         varchar(6)           null,
   businessnumber       varchar(4000)        not null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   ploughtaxmoney       decimal(14,2)        not null,
   ploughtaxdate        datetime             null,
   ploughtaxpaymoney    decimal(14,2)        not null,
   ploughtaxpaydate     datetime             null,
   landtaxallmoney      decimal(14,2)        not null,
   landtaxmoney         decimal(14,2)        not null,
   landtaxbegindate     datetime             null,
   landtaxenddate       datetime             null,
   landtaxmustdate      datetime             null,
   landtaxallpaymoney   decimal(14,2)        not null,
   landtaxpaymoney      decimal(14,2)        not null,
   landtaxpaydate       datetime             null,
   housetaxmoney        decimal(14,2)        not null,
   housetaxallmoney     decimal(14,2)        not null,
   housetaxbegindate    datetime             null,
   housetaxenddate      datetime             null,
   housetaxmustdate     datetime             null,
   housetaxallpaymoney  decimal(14,2)        not null,
   housetaxpaymoney     decimal(14,2)        not null,
   housetaxpaydate      datetime             null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   sellcomparestate     smallint             not null,
   remark               varchar(400)         null,
   illegalcomparestate  smallint             not null,
   estatecomparestate   smallint             not null,
   norentuseflag        varchar(2)           null,
   sourcetaxpayerid     varchar(20)          null,
   sourcetaxpayername   varchar(100)         null,
   onlyhiregroundflag   varchar(2)           null,
   landtaxflag          varchar(2)           null,
   constraint PK_CORE_ESTATE primary key (estateid)
)
go

/*==============================================================*/
/* Table: CORE_HOUSE                                            */
/*==============================================================*/
create table dbo.CORE_HOUSE (
   houseid              varchar(32)          not null,
   estateid             varchar(32)          not null,
   state                smallint             not null,
   housename            varchar(100)         null,
   housetype            smallint             not null,
   expectinvestment     decimal(14,2)        not null,
   plandate             datetime             null,
   buildinginvestment   decimal(14,2)        not null,
   buildingcost         decimal(14,2)        not null,
   devicecost           decimal(14,2)        not null,
   housecertificatetype varchar(2)           null,
   housecertificate     varchar(30)          null,
   housecertificatedate datetime             null,
   usedate              datetime             not null,
   housepurposes        varchar(2)           not null,
   housesource          varchar(2)           not null,
   locationtype         varchar(2)           not null,
   belongtowns          varchar(30)          not null,
   housearea            decimal(14,2)        not null,
   selfusearea          decimal(14,2)        not null,
   hirearea             decimal(14,2)        not null,
   houseoriginalvalue   decimal(14,2)        not null,
   housenetvalue        decimal(14,2)        not null,
   househirereducevalue decimal(14,2)        not null,
   housetaxoriginalvalue decimal(14,2)        not null,
   underground          smallint             not null,
   subjectid            varchar(20)          not null,
   managerid            varchar(20)          not null,
   managertax           smallint             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   businessnumber       varchar(50)          not null,
   treeparentid         varchar(50)          not null,
   businesscode         varchar(6)           null,
   businessid           varchar(4000)        not null,
   treeid               varchar(32)          null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   transmoney           decimal(14,2)        null,
   constraint PK_CORE_HOUSE primary key (houseid)
)
go

/*==============================================================*/
/* Table: CORE_PAYTAX                                           */
/*==============================================================*/
create table dbo.CORE_PAYTAX (
   serialno             varchar(32)          not null,
   taxcode              varchar(20)          not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   levydatetype         varchar(2)           not null,
   taxamountactual      decimal(14,2)        not null,
   taxamountclear       decimal(14,2)        not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   taxlevyorgcode       varchar(11)          not null,
   clearlogid           varchar(32)          null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   taxstate             varchar(2)           null,
   taxclasscode         char(2)              null,
   constraint PK_CORE_PAYTAX primary key (serialno)
)
go

/*==============================================================*/
/* Index: Index_taxpayerid                                      */
/*==============================================================*/
create index Index_taxpayerid on dbo.CORE_PAYTAX (
taxpayerid ASC
)
go

/*==============================================================*/
/* Index: Index_taxdate                                         */
/*==============================================================*/
create index Index_taxdate on dbo.CORE_PAYTAX (
taxdatebegin ASC,
taxdateend ASC
)
go

/*==============================================================*/
/* Index: Index_taxcode                                         */
/*==============================================================*/
create index Index_taxcode on dbo.CORE_PAYTAX (
taxcode ASC
)
go

/*==============================================================*/
/* Table: CORE_TAXABILITY                                       */
/*==============================================================*/
create table dbo.CORE_TAXABILITY (
   taxabilityid         varchar(32)          not null,
   estateid             varchar(32)          not null,
   treeid               varchar(50)          not null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(32)          null,
   state                smallint             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   inputperson          varchar(20)          not null,
   inputdate            datetime             not null,
   checkperson          varchar(20)          not null,
   checkdate            datetime             null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_CORE_TAXABILITY primary key (taxabilityid)
)
go

/*==============================================================*/
/* Table: CORE_TAXABILITYSUB                                    */
/*==============================================================*/
create table dbo.CORE_TAXABILITYSUB (
   subid                varchar(32)          not null,
   taxabilityid         varchar(32)          not null,
   datatype             smallint             not null,
   state                smallint             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         null,
   taxcode              varchar(20)          not null,
   taxmoney             decimal(14,2)        not null,
   taxstate             smallint             not null,
   taxbegindate         datetime             not null,
   taxenddate           datetime             not null,
   paytype              varchar(20)          not null,
   paydate              datetime             not null,
   taxyear              smallint             not null,
   taxmonth             smallint             not null,
   taxquarter           smallint             not null,
   taxhalf              smallint             not null,
   clearlogid           varchar(32)          not null,
   cleardetailid        varchar(32)          not null,
   logmainid            varchar(32)          null,
   taxamountclear       decimal(14,2)        null,
   constraint PK_CORE_TAXABILITYSUB primary key (subid)
)
go

/*==============================================================*/
/* Table: DATAARRANGE_DATASOURCE                                */
/*==============================================================*/
create table dbo.DATAARRANGE_DATASOURCE (
   serialno             varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         null,
   holddate             datetime             null,
   area                 decimal(14,2)        null,
   address              varchar(200)         null,
   landcertificate      varchar(30)          null,
   estateserial         varchar(100)         null,
   getmoney             decimal(14,2)        null,
   telephone            varchar(20)          null,
   importsource         varchar(2)           not null,
   importserialno       varchar(32)          not null,
   importlogserialno    varchar(32)          not null,
   estateid             varchar(32)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   comparestate         varchar(2)           not null,
   matchstate           varchar(2)           not null,
   checkstate           varchar(2)           not null,
   valid                varchar(2)           not null,
   constraint PK_DATAARRANGE_DATASOURCE primary key (serialno)
)
go

/*==============================================================*/
/* Table: DATAARRANGE_DATASOURCESUB                             */
/*==============================================================*/
create table dbo.DATAARRANGE_DATASOURCESUB (
   serialno             varchar(32)          not null,
   mainserialno         varchar(32)          not null,
   taxempcode           varchar(20)          null,
   optdate              datetime             null,
   advice               varchar(200)         null,
   checkempcode         varchar(20)          null,
   checkdate            datetime             null,
   checkcontent         varchar(200)         null,
   constraint PK_DATAARRANGE_DATASOURCESUB primary key (serialno)
)
go

/*==============================================================*/
/* Table: DISTRICT                                              */
/*==============================================================*/
create table dbo.DISTRICT (
   id                   varchar(32)          not null,
   name                 varchar(64)          not null,
   parentid             varchar(32)          null,
   description          varchar(256)         null,
   levels               int                  not null,
   isdetail             int                  not null,
   name_png             varchar(64)          null,
   parentname           varchar(64)          null,
   orgid                int                  not null,
   constraint PK_DISTRICT primary key (id)
)
go

/*==============================================================*/
/* Table: GROUND_LEASEINFO                                      */
/*==============================================================*/
create table dbo.GROUND_LEASEINFO (
   uuid                 varchar(32)          not null,
   leaseagreementno     varchar(32)          not null,
   groundid             varchar(32)          not null,
   leasetaxpayerid      varchar(20)          null,
   leasetaxpayername    varchar(100)         not null,
   ispaygroundtax       varchar(2)           not null,
   leasearea            decimal(14,2)        not null,
   agreeleasearea       decimal(14,2)        null,
   monthrent            decimal(14,2)        not null,
   yearrent             decimal(14,2)        not null,
   leasedatebegin       datetime             not null,
   leasedateend         datetime             not null,
   constraint uuid primary key nonclustered (uuid)
)
go

/*==============================================================*/
/* Table: IMPORT_CONFIG                                         */
/*==============================================================*/
create table dbo.IMPORT_CONFIG (
   sn                   int                  not null,
   modulename           varchar(50)          not null,
   taxorgcode           varchar(11)          not null,
   valid                varchar(2)           not null,
   constraint PK_IMPORT_CONFIG primary key (sn)
)
go

/*==============================================================*/
/* Table: IMPORT_CONFIGFIELD                                    */
/*==============================================================*/
create table dbo.IMPORT_CONFIGFIELD (
   fieldid              int                  not null,
   subid                int                  not null,
   colnumno             int                  not null,
   fieldname            varchar(30)          not null,
   fieldcaption         varchar(50)          not null,
   datatype             varchar(10)          not null,
   datalength           varchar(10)          not null,
   getvaluetype         smallint             not null,
   defaultvalue         varchar(50)          not null,
   valid                varchar(2)           not null,
   parentkeyvaluefield  varchar(300)         not null,
   constraint PK_IMPORT_CONFIGFIELD primary key (fieldid)
)
go

/*==============================================================*/
/* Table: IMPORT_CONFIGSUB                                      */
/*==============================================================*/
create table dbo.IMPORT_CONFIGSUB (
   subid                int                  not null,
   sn                   int                  not null,
   moduletype           smallint             not null,
   tablename            varchar(30)          not null,
   filetype             varchar(10)          not null,
   sheetindex           smallint             not null,
   startrow             int                  not null,
   startcol             int                  not null,
   valid                varchar(2)           not null,
   constraint PK_IMPORT_CONFIGSUB primary key (subid)
)
go

/*==============================================================*/
/* Table: IMPORT_EMPLOYLAND                                     */
/*==============================================================*/
create table dbo.IMPORT_EMPLOYLAND (
   employland           varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         not null,
   linkphone            varchar(30)          null,
   district             varchar(50)          not null,
   address              varchar(100)         not null,
   landtype             varchar(20)          not null,
   area                 decimal(14,2)        not null,
   getmoney             decimal(14,2)        not null,
   employdate           datetime             not null,
   importkey            varchar(32)          not null,
   exportstate          smallint             not null,
   taxorgsupcode        varchar(20)          null,
   taxorgcode           varchar(20)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   constraint PK_IMPORT_EMPLOYLAND primary key (employland)
)
go

/*==============================================================*/
/* Table: IMPORT_ESTATE                                         */
/*==============================================================*/
create table dbo.IMPORT_ESTATE (
   estateid             varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         not null,
   address              varchar(100)         not null,
   landcertificate      varchar(30)          null,
   estateserial         varchar(30)          null,
   area                 decimal(14,2)        not null,
   providedate          datetime             not null,
   importkey            varchar(32)          not null,
   exportstate          smallint             not null,
   taxorgsupcode        varchar(20)          null,
   taxorgcode           varchar(20)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   purpose              varchar(50)          null,
   ownership            varchar(50)          null,
   constraint PK_IMPORT_ESTATE primary key (estateid)
)
go

/*==============================================================*/
/* Table: IMPORT_EXCEL_CONFIG_MAIN                              */
/*==============================================================*/
create table dbo.IMPORT_EXCEL_CONFIG_MAIN (
   mainid               varchar(32)          not null,
   configname           varchar(100)         not null,
   startrow             int                  not null,
   endrow               int                  not null,
   receiveobj           varchar(100)         not null,
   procobj              varchar(100)         not null,
   constraint PK_IMPORT_EXCEL_CONFIG_MAIN primary key (mainid)
)
go

/*==============================================================*/
/* Table: IMPORT_EXCEL_CONFIG_SUB                               */
/*==============================================================*/
create table dbo.IMPORT_EXCEL_CONFIG_SUB (
   subid                varchar(32)          not null,
   mainid               varchar(32)          not null,
   propname             varchar(30)          not null,
   excelcol             int                  not null,
   constraint PK_IMPORT_EXCEL_CONFIG_SUB primary key (subid)
)
go

/*==============================================================*/
/* Table: IMPORT_LANDSTORE                                      */
/*==============================================================*/
create table dbo.IMPORT_LANDSTORE (
   landstoreid          varchar(32)          not null,
   approvetype          varchar(20)          not null,
   district             varchar(30)          not null,
   name                 varchar(100)         not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         not null,
   approvenumber        varchar(50)          null,
   approvenumbercity    varchar(50)          null,
   approvedate          datetime             not null,
   areatotal            decimal(14,2)        not null,
   areaplough           decimal(14,2)        not null,
   areabuild            decimal(14,2)        not null,
   areauseless          decimal(14,2)        not null,
   importkey            varchar(32)          not null,
   exportstate          smallint             not null,
   taxorgsupcode        varchar(20)          null,
   taxorgcode           varchar(20)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   constraint PK_IMPORT_LANDSTORE primary key (landstoreid)
)
go

/*==============================================================*/
/* Table: IMPORT_LANDSTORESUB                                   */
/*==============================================================*/
create table dbo.IMPORT_LANDSTORESUB (
   landstorsubid        varchar(32)          not null,
   landstorid           varchar(32)          not null,
   location             varchar(50)          not null,
   detailaddress        varchar(100)         not null,
   areatotal            decimal(14,2)        not null,
   areaplough           decimal(14,2)        not null,
   areabuild            decimal(14,2)        not null,
   areauseless          decimal(14,2)        not null,
   areasell             decimal(14,2)        not null,
   importkey            varchar(32)          not null,
   importparentkey      varchar(32)          not null,
   approvenumber        varchar(50)          null,
   constraint PK_IMPORT_LANDSTORESUB primary key (landstorsubid)
)
go

/*==============================================================*/
/* Table: IMPORT_LOG                                            */
/*==============================================================*/
create table dbo.IMPORT_LOG (
   id                   varchar(32)          not null,
   sn                   int                  not null,
   filename             varchar(100)         not null,
   optdate              datetime             not null,
   optempcode           varchar(20)          not null,
   taxorgcode           varchar(11)          not null,
   sumcount             int                  not null,
   matecount            int                  null,
   writecount           int                  null,
   constraint PK_IMPORT_LOG primary key (id)
)
go

/*==============================================================*/
/* Table: IMPORT_MATETAXPAYER                                   */
/*==============================================================*/
create table dbo.IMPORT_MATETAXPAYER (
   id                   varchar(32)          not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   importtaxpayername   varchar(100)         not null,
   optempcode           varchar(20)          not null,
   taxorgsupcode        varchar(20)          not null,
   taxorgcode           varchar(20)          not null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          not null,
   constraint PK_IMPORT_MATETAXPAYER primary key (id)
)
go

/*==============================================================*/
/* Table: IMPORT_SELLLAND                                       */
/*==============================================================*/
create table dbo.IMPORT_SELLLAND (
   selllandid           varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   importtaxpayername   varchar(100)         not null,
   address              varchar(100)         not null,
   estateserial         varchar(30)          null,
   purpose              varchar(30)          not null,
   area                 decimal(14,2)        not null,
   getmoney             decimal(14,2)        not null,
   selldate             datetime             not null,
   importkey            varchar(32)          not null,
   exportstate          smallint             not null,
   taxorgsupcode        varchar(20)          null,
   taxorgcode           varchar(20)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   constraint PK_IMPORT_SELLLAND primary key (selllandid)
)
go

/*==============================================================*/
/* Table: INIT_COMPARGAIN                                       */
/*==============================================================*/
create table dbo.INIT_COMPARGAIN (
   compargainid         varchar(32)          not null,
   compargainmainid     varchar(32)          not null,
   landsourceid         varchar(32)          not null,
   estateid             varchar(32)          null,
   state                smallint             not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         null,
   landserial           varchar(30)          not null,
   landcertificate      varchar(30)          null,
   gaindate             datetime             null,
   gaindetailaddress    varchar(100)         not null,
   areatotal            decimal(14,2)        not null,
   estatetaxpayer       varchar(20)          not null,
   estatetaxpayername   varchar(100)         null,
   estateserial         varchar(30)          null,
   landcertificatetaxpayer varchar(30)          null,
   holddate             datetime             null,
   detailaddress        varchar(100)         not null,
   estateareatotal      decimal(14,2)        not null,
   remark               varchar(200)         not null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   confirmperson        varchar(20)          null,
   constraint PK_INIT_COMPARGAIN primary key (compargainid)
)
go

/*==============================================================*/
/* Table: INIT_COMPARGAINMAIN                                   */
/*==============================================================*/
create table dbo.INIT_COMPARGAINMAIN (
   compargainmainid     varchar(32)          not null,
   comparedate          datetime             not null,
   compareperson        varchar(20)          not null,
   comparetype          smallint             not null,
   aotumatecount        int                  not null,
   manmatecount         int                  not null,
   nomatecount          int                  not null,
   linknomatecount      int                  not null,
   estatenomatecount    int                  not null,
   constraint PK_INIT_COMPARGAINMAIN primary key (compargainmainid)
)
go

/*==============================================================*/
/* Table: INIT_EMPLOYLAND                                       */
/*==============================================================*/
create table dbo.INIT_EMPLOYLAND (
   employland           varchar(32)          not null,
   taxpayerid           varchar(11)          not null,
   taxpayername         varchar(100)         not null,
   landtype             varchar(20)          not null,
   district             varchar(50)          not null,
   address              varchar(100)         not null,
   area                 decimal(14,2)        not null,
   employdate           datetime             not null,
   getmoney             decimal(14,2)        not null,
   linkphone            varchar(30)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   state                smallint             not null,
   constraint PK_INIT_EMPLOYLAND primary key (employland)
)
go

/*==============================================================*/
/* Table: INIT_ESTATE                                           */
/*==============================================================*/
create table dbo.INIT_ESTATE (
   estateid             varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         not null,
   importtaxpayername   varchar(100)         not null,
   address              varchar(100)         not null,
   landcertificate      varchar(30)          null,
   estateserial         varchar(30)          null,
   area                 decimal(14,2)        not null,
   providedate          datetime             not null,
   state                smallint             not null,
   taxorgsupcode        varchar(20)          not null,
   taxorgcode           varchar(20)          not null,
   taxdeptcode          varchar(20)          null,
   taxmanagercode       varchar(20)          not null,
   purpose              varchar(50)          null,
   ownership            varchar(50)          null,
   constraint PK_INIT_ESTATE primary key (estateid)
)
go

/*==============================================================*/
/* Table: KEY_DISTRICTNUMBER                                    */
/*==============================================================*/
create table dbo.KEY_DISTRICTNUMBER (
   taxorgcode           varchar(20)          not null,
   districtid           varchar(32)          not null,
   keyvalue             decimal(10)          not null,
   constraint PK_KEY_DISTRICTNUMBER primary key (taxorgcode, districtid)
)
go

/*==============================================================*/
/* Table: KEY_TABLEKEYVALUES                                    */
/*==============================================================*/
create table dbo.KEY_TABLEKEYVALUES (
   taxorgcode           varchar(11)          not null,
   keyname              varchar(100)         not null,
   formatpro            varchar(30)          null,
   maxvalue             decimal(20)          not null,
   datalength           int                  null,
   last_frtime          datetime             not null,
   constraint PK_KEY_TABLEKEYVALUES primary key (taxorgcode, keyname)
)
go

/*==============================================================*/
/* Table: LEV_LEVYCALENDAR                                      */
/*==============================================================*/
create table dbo.LEV_LEVYCALENDAR (
   levydatetype         varchar(4)           not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             null,
   levydatebegin        datetime             null,
   levydateend          datetime             null,
   taxorgcode           varchar(11)          not null,
   constraint PK_LEV_LEVYCALENDAR primary key nonclustered (levydatetype, taxdatebegin, taxorgcode)
)
go

/*==============================================================*/
/* Table: LEV_LEVYDATETYPE                                      */
/*==============================================================*/
create table dbo.LEV_LEVYDATETYPE (
   levydatetype         varchar(4)           not null,
   levydatedesc         varchar(100)         null,
   levydatecycle        int                  null,
   levydateflag         int                  null,
   levydatebegin        int                  null,
   levydateend          int                  null,
   typevalid            int                  null,
   taxorgcode           varchar(11)          not null,
   flag                 varchar(2)           not null,
   constraint PK_LEVYDATETYPE primary key (levydatetype, taxorgcode)
)
go

/*==============================================================*/
/* Table: LEV_TAXBILLDETAILCASHBANK                             */
/*==============================================================*/
create table dbo.LEV_TAXBILLDETAILCASHBANK (
   taxbillno            varchar(20)          not null,
   printcount           int                  not null,
   recno                int                  not null,
   taxbilltypecode      char(2)              not null,
   taxtypecode          varchar(6)           not null,
   taxcode              varchar(6)           not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   taxpayerbusiaddr     varchar(200)         not null,
   taxbillnoprt         varchar(40)          not null,
   makedate             datetime             not null,
   makedatetime         datetime             not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   taxdeadline          datetime             not null,
   bankcode             varchar(15)          null,
   account              varchar(40)          null,
   econaturecode        varchar(6)           not null,
   acceconaturecode     varchar(6)           not null,
   callingcode          varchar(10)          not null,
   acccallingcode       varchar(6)           not null,
   subjectioncode       varchar(2)           not null,
   belongtocountrycode  varchar(10)          not null,
   nationbankcode       varchar(6)           not null,
   budgetclasscode      varchar(2)           not null,
   budgetcode           varchar(12)          not null,
   taxingamount         decimal(14,2)        not null,
   taxingquantity       decimal(14,2)        not null,
   taxrate              decimal(14,6)        not null,
   taxamountpaid        decimal(14,2)        not null,
   taxamountderate      decimal(14,2)        not null,
   taxamountactual      decimal(14,2)        not null,
   taxclasscode         char(2)              not null,
   statecontrolflag     char(2)              not null,
   levydatetype         char(2)              not null,
   taxderatecode        varchar(4)           null,
   taxderatetype        char(2)              null,
   taxempcode           varchar(20)          not null,
   taxorgsupcode        varchar(11)          not null,
   taxlevyorgcode       varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   declaretypecode      char(2)              not null,
   overduelevy          char(1)              not null,
   bookno               varchar(100)         not null,
   foreignerflag        int                  not null,
   cashprocflag         int                  not null,
   cashprocempcode      varchar(20)          null,
   cashprocorgcode      varchar(11)          null,
   cashsumno            varchar(24)          not null,
   handinflag           varchar(6)           not null,
   memo1                varchar(60)          null,
   memo2                varchar(60)          null,
   memo3                varchar(60)          null,
   memo4                varchar(60)          null,
   memo5                varchar(60)          null,
   returntable          varchar(200)         null,
   accountcode          varchar(10)          not null,
   accempcode           varchar(20)          null,
   accdate              datetime             null,
   classprintcode       varchar(100)         null,
   sumflag              varchar(30)          null,
   constraint PK_Levy_TaxBillDetailCashBank primary key nonclustered (taxbillno, printcount, recno)
)
go

/*==============================================================*/
/* Index: IDX_TaxPayerId                                        */
/*==============================================================*/
create index IDX_TaxPayerId on dbo.LEV_TAXBILLDETAILCASHBANK (
taxpayerid ASC
)
go

/*==============================================================*/
/* Index: IDX_LEVBILL_BOOKNO                                    */
/*==============================================================*/
create index IDX_LEVBILL_BOOKNO on dbo.LEV_TAXBILLDETAILCASHBANK (
bookno ASC
)
go

/*==============================================================*/
/* Index: idx_cashsumno                                         */
/*==============================================================*/
create index idx_cashsumno on dbo.LEV_TAXBILLDETAILCASHBANK (
cashsumno ASC
)
go

/*==============================================================*/
/* Index: IDX_TAXTYPECODE_LEV                                   */
/*==============================================================*/
create index IDX_TAXTYPECODE_LEV on dbo.LEV_TAXBILLDETAILCASHBANK (
taxcode ASC
)
go

/*==============================================================*/
/* Index: IDX_MAKEDATETIME                                      */
/*==============================================================*/
create index IDX_MAKEDATETIME on dbo.LEV_TAXBILLDETAILCASHBANK (
makedatetime ASC
)
go

/*==============================================================*/
/* Index: IDX_LEVBILLCASHBANK_EMPCODE                           */
/*==============================================================*/
create index IDX_LEVBILLCASHBANK_EMPCODE on dbo.LEV_TAXBILLDETAILCASHBANK (
taxempcode ASC
)
go

/*==============================================================*/
/* Index: IDX_LEVBILL_MAKEDATEORG                               */
/*==============================================================*/
create index IDX_LEVBILL_MAKEDATEORG on dbo.LEV_TAXBILLDETAILCASHBANK (
makedate DESC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Index: IDX_LEVBILL_ACCDATEORG                                */
/*==============================================================*/
create index IDX_LEVBILL_ACCDATEORG on dbo.LEV_TAXBILLDETAILCASHBANK (
accdate ASC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Table: MAP_BELONGTOCOUNTRYTAXORGCODE                         */
/*==============================================================*/
create table dbo.MAP_BELONGTOCOUNTRYTAXORGCODE (
   serialno             varchar(32)          not null,
   belongtocountrycode  varchar(10)          not null,
   taxorgcode           varchar(11)          not null,
   constraint PK_MAP_BELONGTOCOUNTRYTAXORGCO primary key (serialno)
)
go

/*==============================================================*/
/* Index: IDX_BELONGTCOUNTRYMAPTAXORG                           */
/*==============================================================*/
create unique index IDX_BELONGTCOUNTRYMAPTAXORG on dbo.MAP_BELONGTOCOUNTRYTAXORGCODE (
belongtocountrycode ASC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Table: MAP_BELONGTOWNTOLEVELRATE                             */
/*==============================================================*/
create table dbo.MAP_BELONGTOWNTOLEVELRATE (
   belongtowns          varchar(30)          not null,
   groundtaxrate        decimal(14,6)        not null,
   landtaxflag          varchar(2)           not null,
   constraint PK_MAP_BELONGTOWNTOLEVELRATE primary key (belongtowns)
)
go

/*==============================================================*/
/* Table: MAP_HOUSETOGROUND                                     */
/*==============================================================*/
create table dbo.MAP_HOUSETOGROUND (
   serialno             varchar(32)          not null,
   houseid              varchar(32)          not null,
   estateid             varchar(32)          not null,
   begindate            datetime             not null,
   useflag              varchar(2)           not null,
   valid                varchar(2)           not null,
   constraint PK_MAP_HOUSETOGROUND primary key (serialno)
)
go

/*==============================================================*/
/* Table: MAP_OLDESTATEIDTONEWESTATEID                          */
/*==============================================================*/
create table dbo.MAP_OLDESTATEIDTONEWESTATEID (
   oldestateid          varchar(32)          not null,
   newestateid          varchar(32)          not null,
   constraint PK_MAP_OLDESTATEIDTONEWESTATEI primary key (oldestateid)
)
go

/*==============================================================*/
/* Table: MAP_TAXCODELEVYDATETYPE                               */
/*==============================================================*/
create table dbo.MAP_TAXCODELEVYDATETYPE (
   serialno             varchar(10)          not null,
   taxcode              varchar(6)           not null,
   taxorgcode           varchar(11)          not null,
   levydatetype         varchar(4)           not null,
   constraint PK_MAP_TAXCODELEVYDATETYPE primary key (serialno)
)
go

/*==============================================================*/
/* Table: OTHER_WORKEVALUATE                                    */
/*==============================================================*/
create table dbo.OTHER_WORKEVALUATE (
   id                   int                  identity,
   evaluatedate         datetime             not null,
   taxorgcode           char(20)             not null,
   logincode            char(20)             not null,
   taxempname           char(100)            not null,
   evaluatevalue        int                  not null,
   constraint PK_Other_WorkEvaluate primary key (id)
)
go

/*==============================================================*/
/* Table: POL_GROUNDREGIST                                      */
/*==============================================================*/
create table dbo.POL_GROUNDREGIST (
   taxpayername         varchar(300)         not null,
   taxpayerid           varchar(20)          not null,
   groundno             varchar(10)          not null,
   groundname           varchar(100)         null,
   groundusertypecode   char(2)              not null,
   groundtypecode       char(2)              null,
   groundlevelcode      varchar(10)          null,
   groundarea           decimal(14,2)        not null,
   taxarea              decimal(14,2)        not null,
   nottaxarea           decimal(14,2)        null,
   taxrate              decimal(14,2)        null,
   taxsumyear           decimal(14,2)        not null,
   groundcounty         varchar(6)           null,
   groundstreet         varchar(255)         null,
   groundadress         varchar(255)         null,
   groundtaxorgcode     varchar(11)          null,
   groundusecerno       varchar(200)         not null,
   groundmagno          varchar(20)          null,
   groundusekindcode    char(2)              null,
   groundusemodecode    char(2)              null,
   groundsourcecode     char(2)              null,
   groundusecode        char(2)              null,
   groundusearea        decimal(18,2)        null,
   groundusedate        datetime             null,
   lendname             varchar(60)          null,
   lendcertype          varchar(6)           null,
   lendcerno            varchar(30)          null,
   confirmer            varchar(20)          null,
   confirmdate          datetime             null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          not null,
   optdate              datetime             not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxmanagercode       varchar(20)          not null,
   remak                varchar(255)         null,
   constraint POL_GROUNDREGIST_copy_x primary key nonclustered (taxpayerid, groundno)
)
go

/*==============================================================*/
/* Table: POL_TAXRATE                                           */
/*==============================================================*/
create table dbo.POL_TAXRATE (
   taxtypecode          char(2)              not null,
   taxcode              varchar(6)           not null,
   taxrate              decimal(14,6)        not null,
   taxrateright         decimal(14,2)        not null,
   qcdata               decimal(14,2)        not null,
   acccallingcode       varchar(6)           null,
   acceconaturecode     varchar(6)           null,
   defaultflag          char(2)              not null,
   taxorgcode           varchar(11)          not null,
   optorgcode           varchar(11)          not null,
   optempcode           varchar(20)          not null,
   constraint PK_TAXRATE primary key (taxtypecode, taxcode, taxrate, taxorgcode)
)
go

/*==============================================================*/
/* Table: PRM_REG_PARAMS                                        */
/*==============================================================*/
create table dbo.PRM_REG_PARAMS (
   serialno             varchar(32)          not null,
   taxorgcode           varchar(11)          not null,
   parametername        varchar(20)          not null,
   parametervalue       varchar(100)         not null,
   parameterdesc        varchar(100)         not null,
   remark               varchar(100)         null,
   constraint PK_PRM_REG_PARAMS primary key nonclustered (serialno)
)
go

/*==============================================================*/
/* Index: IDX_REGPARAMS                                         */
/*==============================================================*/
create unique index IDX_REGPARAMS on dbo.PRM_REG_PARAMS (
parametername ASC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Table: REG_TAXREGISTMAIN                                     */
/*==============================================================*/
create table dbo.REG_TAXREGISTMAIN (
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   propertypecode       char(2)              not null,
   taxcerno             varchar(30)          not null,
   legalpersonname      varchar(20)          not null,
   legalpersoncertypecode char(2)              not null,
   legalpersoncerno     varchar(20)          not null,
   telephone            varchar(20)          null,
   adminareacode        varchar(6)           not null,
   orgunifycode         varchar(20)          null,
   busimanageaddr       varchar(200)         not null,
   registeraddr         varchar(200)         not null,
   busiscope            varchar(200)         not null,
   busibegindate        datetime             null,
   busienddate          datetime             null,
   busiopendate         datetime             not null,
   busimode             varchar(60)          null,
   econaturecode        varchar(6)           not null,
   callingcode          varchar(6)           not null,
   taxcontactperson     varchar(20)          not null,
   taxcontactpersontel  varchar(20)          not null,
   subjectioncode       char(2)              not null,
   taxcervalidbegindate datetime             null,
   taxcervalidenddate   datetime             null,
   taxregisterdate      datetime             not null,
   taxcerorgcode        varchar(11)          not null,
   taxempcode           varchar(20)          not null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   defaultnationbankcode varchar(6)           null,
   defaultbudgetclasscode char(2)              null,
   taxpayerstatuscode   char(2)              null,
   busicountmode        char(2)              null,
   taxregstatus         char(2)              null,
   belongtosystem       varchar(20)          null,
   belongtocountrycode  varchar(10)          not null,
   belongtoarea         varchar(100)         null,
   declaremodecode      char(2)              not null,
   imposemodecode       varchar(2)           not null,
   manageflag           char(2)              not null,
   statecontrolflag     char(2)              not null,
   downlevypoint        char(2)              not null,
   regularflag          char(2)              not null,
   condominiumflag      char(2)              not null,
   fungibleflag         char(2)              not null,
   deductflag           char(2)              not null,
   taxclearflag         char(2)              not null,
   invclearflag         char(2)              not null,
   auditflag            char(2)              not null,
   checkflag            char(2)              not null,
   outfareflag          char(2)              not null,
   infotypeflag         char(2)              not null,
   freightselfflag      char(2)              not null,
   freightsupplyflag    char(2)              not null,
   invstopsupplyflag    char(2)              not null,
   mainextendedkey      varchar(100)         null,
   regtype              varchar(2)           null,
   regtypedetail        varchar(2)           null,
   constraint PK_TAXREGISTMAIN primary key (taxpayerid)
)
go

/*==============================================================*/
/* Index: IDX_TaxRegisterDate                                   */
/*==============================================================*/
create index IDX_TaxRegisterDate on dbo.REG_TAXREGISTMAIN (
taxregisterdate ASC
)
go

/*==============================================================*/
/* Index: IDX_SUPORG                                            */
/*==============================================================*/
create index IDX_SUPORG on dbo.REG_TAXREGISTMAIN (
taxorgsupcode ASC
)
go

/*==============================================================*/
/* Index: IDX_REGISTMAIN_NAME                                   */
/*==============================================================*/
create index IDX_REGISTMAIN_NAME on dbo.REG_TAXREGISTMAIN (
taxpayername ASC
)
go

/*==============================================================*/
/* Index: IDX_TAXREGISTMAIN_TAXCERNO                            */
/*==============================================================*/
create index IDX_TAXREGISTMAIN_TAXCERNO on dbo.REG_TAXREGISTMAIN (
taxcerno ASC
)
go

/*==============================================================*/
/* Index: idx_taxorgcode                                        */
/*==============================================================*/
create index idx_taxorgcode on dbo.REG_TAXREGISTMAIN (
taxorgcode ASC
)
go

/*==============================================================*/
/* Index: IDX_TaxRegisterDateOrg                                */
/*==============================================================*/
create index IDX_TaxRegisterDateOrg on dbo.REG_TAXREGISTMAIN (
taxregisterdate DESC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Index: IDX_ORGDATE                                           */
/*==============================================================*/
create index IDX_ORGDATE on dbo.REG_TAXREGISTMAIN (
busiopendate DESC,
taxorgcode ASC
)
go

/*==============================================================*/
/* Table: REG_TAXREGISTSUB                                      */
/*==============================================================*/
create table dbo.REG_TAXREGISTSUB (
   taxpayerid           varchar(20)          not null,
   budgetmanagemode     varchar(2)           null,
   partnershipemployeeamount decimal(18)          null,
   employeeamount       decimal(18)          null,
   subemployeeamount    decimal(18)          null,
   financemanager       varchar(20)          null,
   financemanagertel    varchar(20)          null,
   registercapitalsum   decimal(14,2)        null,
   regcapcurrtypecode   varchar(3)           null,
   lowvalueamortizecode char(2)              null,
   depreciationmode     char(2)              null,
   taxpayerenglishname  varchar(100)         null,
   busichargedeptcode   varchar(8)           null,
   busilicencetypecode  varchar(2)           null,
   busilicenceno        varchar(30)          null,
   busilicencemakedate  datetime             null,
   confirmorgname       varchar(60)          null,
   contractconfirmdocno varchar(50)          null,
   contractconfirmdate  datetime             null,
   busimanageaddrpostcode varchar(6)           null,
   registeraddrpostcode varchar(6)           null,
   legalpersonmobilephone varchar(20)          null,
   legalpersonemail     varchar(40)          null,
   nativeplace          varchar(100)         null,
   busimanageaddrtel    varchar(20)          null,
   registeraddrtel      varchar(20)          null,
   financemanagercertypecode varchar(2)           null,
   financemanagercerno  varchar(20)          null,
   financemanagermobile varchar(20)          null,
   financemanageremaill varchar(40)          null,
   taxcontactpersoncertypecode varchar(2)           null,
   taxcontactpersoncerno varchar(20)          null,
   taxcontactpersonmobile varchar(20)          null,
   taxcontactpersonemail varchar(40)          null,
   accyearcode          varchar(2)           null,
   taxvicariousname     varchar(100)         null,
   taxvicariouscerno    varchar(30)          null,
   taxvicarioustel      varchar(20)          null,
   taxvicariousemail    varchar(40)          null,
   currtypecode1        varchar(3)           null,
   capital1             decimal(14,2)        null,
   Currtypecode2        varchar(3)           null,
   Capital2             decimal(14,2)        null,
   Currtypecode3        varchar(3)           null,
   Capital3             decimal(14,2)        null,
   personinvestscale    decimal(14,6)        null,
   foreigninvestscale   decimal(14,6)        null,
   nationinvestscale    decimal(14,6)        null,
   nationaltaxorgcode   varchar(11)          null,
   nationaltaxdeptcode  varchar(11)          null,
   subextendedkey1      varchar(100)         null,
   subextendedkey2      varchar(100)         null,
   constraint PK_TAXREGISTSUB primary key (taxpayerid)
)
go

/*==============================================================*/
/* Table: REG_TAXTYPEREGISTER                                   */
/*==============================================================*/
create table dbo.REG_TAXTYPEREGISTER (
   serialno             varchar(32)          not null,
   taxpayerid           varchar(20)          not null,
   taxtypecode          varchar(6)           null,
   taxcode              varchar(6)           not null,
   taxrate              decimal(14,6)        not null,
   budgetcode           varchar(12)          not null,
   imposemodecode       varchar(2)           not null,
   imposemodemapcode    varchar(2)           not null,
   taxdatetype          varchar(4)           not null,
   classallotflag       char(2)              not null,
   taxingamount         decimal(14,2)        null,
   taxingquantity       decimal(14,2)        null,
   taxamountpaid        decimal(14,2)        null,
   ratifyamount         decimal(14,2)        null,
   undeclarecountflag   char(2)              not null,
   taxdatetype2         varchar(4)           null,
   serialno2            varchar(32)          null,
   optorgcode           varchar(11)          not null,
   optempcode           varchar(20)          not null,
   optdate              datetime             not null,
   constraint REG_TAXTYP_21252996501 primary key (serialno)
)
go

/*==============================================================*/
/* Index: IDX_TAXTYPEREGISTER                                   */
/*==============================================================*/
create unique index IDX_TAXTYPEREGISTER on dbo.REG_TAXTYPEREGISTER (
taxpayerid ASC,
taxcode ASC,
taxrate ASC,
taxdatetype ASC,
serialno2 ASC
)
go

/*==============================================================*/
/* Index: IDX_TAXPAYERID                                        */
/*==============================================================*/
create index IDX_TAXPAYERID on dbo.REG_TAXTYPEREGISTER (
taxpayerid ASC
)
go

/*==============================================================*/
/* Index: IDX_TAXTYPEREGISTER_NO2                               */
/*==============================================================*/
create index IDX_TAXTYPEREGISTER_NO2 on dbo.REG_TAXTYPEREGISTER (
serialno2 ASC
)
go

/*==============================================================*/
/* Index: IDX_TAXTYPEREGIST_ORGCODE                             */
/*==============================================================*/
create index IDX_TAXTYPEREGIST_ORGCODE on dbo.REG_TAXTYPEREGISTER (
optorgcode ASC
)
go

/*==============================================================*/
/* Table: RULE_TAXSOURCE                                        */
/*==============================================================*/
create table dbo.RULE_TAXSOURCE (
   taxsourceid          int                  not null,
   businesscode         varchar(6)           not null,
   serialnumber         int                  not null,
   taxcountcode         varchar(4)           not null,
   tablename            varchar(50)          not null,
   keyfieldname         varchar(50)          not null,
   remark               varchar(400)         not null
)
go

/*==============================================================*/
/* Table: RULE_TAXSOURCESUB                                     */
/*==============================================================*/
create table dbo.RULE_TAXSOURCESUB (
   taxsourcesubid       int                  not null,
   taxsourceid          int                  not null,
   parametername        varchar(50)          not null,
   linktablename        varchar(50)          null,
   linkkeyfieldname     varchar(50)          not null,
   linkfieldname        varchar(50)          null,
   fieldname            varchar(50)          not null,
   datetype             smallint             not null,
   iscount              smallint             not null
)
go

/*==============================================================*/
/* Table: SAM_DATAAUTHCONFIG                                    */
/*==============================================================*/
create table dbo.SAM_DATAAUTHCONFIG (
   serialno             varchar(32)          not null,
   authusercode         varchar(20)          null,
   authtype             varchar(4)           null,
   authvalue            varchar(255)         null,
   authremark           varchar(200)         null,
   valid                varchar(2)           null
)
go

/*==============================================================*/
/* Table: SYSTEM_ALLCODE_MAIN                                   */
/*==============================================================*/
create table dbo.SYSTEM_ALLCODE_MAIN (
   codetablename        varchar(100)         not null,
   codekey              varchar(32)          not null,
   codevalue            varchar(32)          not null,
   codevoname           varchar(100)         not null,
   enabled              varchar(2)           not null,
   constraint PK_SYSTEM_ALLCODE_MAI primary key nonclustered (codetablename)
)
go

/*==============================================================*/
/* Table: SYSTEM_GROUP2RESOURCE                                 */
/*==============================================================*/
create table dbo.SYSTEM_GROUP2RESOURCE (
   serial_id            varchar(32)          not null,
   group_id             varchar(32)          not null,
   resource_id          varchar(32)          not null,
   constraint PK_SYSTEM_GROUP2RESOURCE primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_GROUP2ROLE                                     */
/*==============================================================*/
create table dbo.SYSTEM_GROUP2ROLE (
   serial_id            varchar(32)          not null,
   group_id             varchar(32)          not null,
   role_id              varchar(32)          not null,
   constraint PK_SYSTEM_GROUP2ROLE primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_RESOURCES                                      */
/*==============================================================*/
create table dbo.SYSTEM_RESOURCES (
   resource_id          varchar(32)          not null,
   resource_name        varchar(64)          null,
   resource_type        varchar(64)          not null,
   resource_content     varchar(200)         not null,
   resouce_describe     varchar(64)          null,
   enabled              varchar(1)           not null,
   parent_menu_id       varchar(32)          null,
   leaf_type            varchar(32)          null,
   sort_str             varchar(10)          null,
   selfId               varchar(20)          null,
   parentId             varchar(20)          null,
   isDouble             varchar(10)          null,
   bgColor              varchar(20)          null,
   tileType             varchar(10)          null,
   imgSrc               varchar(100)         null,
   brandName            varchar(50)          null,
   brandCount           varchar(4)           null,
   badgeColor           varchar(10)          null,
   tileHtml             varchar(1000)        null,
   menuIcon             varchar(50)          null,
   menuUrl              varchar(100)         null,
   todoUrl              varchar(100)         null,
   todoMenuid           varchar(100)         null,
   constraint PK_SYSTEM_RESOURCES primary key (resource_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_ROLE2RESOURCE                                  */
/*==============================================================*/
create table dbo.SYSTEM_ROLE2RESOURCE (
   serial_id            varchar(32)          not null,
   role_id              varchar(32)          not null,
   resource_id          varchar(32)          not null,
   constraint PK_SYSTEM_ROLE2RESOURCE primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_ROLES                                          */
/*==============================================================*/
create table dbo.SYSTEM_ROLES (
   role_id              varchar(32)          not null,
   role_code            varchar(64)          not null,
   role_describe        varchar(64)          not null,
   enabled              varchar(1)           not null,
   constraint PK_SYSTEM_ROLES primary key (role_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USER2GROUP                                     */
/*==============================================================*/
create table dbo.SYSTEM_USER2GROUP (
   serial_id            varchar(32)          not null,
   user_id              varchar(32)          not null,
   group_id             varchar(32)          not null,
   constraint PK_SYSTEM_USER2GROUP primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USER2RESOURCE                                  */
/*==============================================================*/
create table dbo.SYSTEM_USER2RESOURCE (
   serial_id            varchar(32)          not null,
   user_id              varchar(32)          not null,
   resource_id          varchar(32)          not null,
   constraint PK_SYSTEM_USER2RESOURCE primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USER2ROLE                                      */
/*==============================================================*/
create table dbo.SYSTEM_USER2ROLE (
   serial_id            varchar(32)          not null,
   user_id              varchar(32)          not null,
   role_id              varchar(32)          not null,
   constraint PK_SYSTEM_USER2ROLE primary key (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USER2ROLE_copy                                 */
/*==============================================================*/
create table dbo.SYSTEM_USER2ROLE_copy (
   serial_id            varchar(32)          not null,
   user_id              varchar(32)          not null,
   role_id              varchar(32)          not null,
   constraint SYSTEM_USER2ROLE_x primary key nonclustered (serial_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USERGROUPS                                     */
/*==============================================================*/
create table dbo.SYSTEM_USERGROUPS (
   group_id             varchar(32)          not null,
   group_code           varchar(64)          not null,
   group_describe       varchar(64)          not null,
   group_type           varchar(10)          not null,
   enabled              varchar(1)           not null,
   constraint PK_SYSTEM_USERGROUPS primary key (group_id)
)
go

/*==============================================================*/
/* Table: SYSTEM_USERS                                          */
/*==============================================================*/
create table dbo.SYSTEM_USERS (
   user_id              varchar(32)          not null,
   user_code            varchar(64)          not null,
   password             varchar(64)          not null,
   user_type            varchar(10)          not null,
   user_describe        varchar(64)          null,
   enabled              varchar(1)           not null,
   group_id             varchar(32)          null,
   user_detail_info_id  varchar(32)          null,
   constraint PK_SYSTEM_USERS primary key (user_id)
)
go

/*==============================================================*/
/* Table: TAX_ABNORMALOPERATION                                 */
/*==============================================================*/
create table dbo.TAX_ABNORMALOPERATION (
   taxpayerid           varchar(20)          not null,
   taxcode              varchar(6)           not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   recno                int                  not null,
   optempcode           varchar(20)          null,
   optdate              datetime             null,
   opttype              varchar(2)           null,
   optopinion           varchar(200)         null,
   checkempcode         varchar(20)          null,
   checkdate            datetime             null,
   checktype            varchar(2)           null,
   checkopinion         varchar(200)         null,
   constraint PK_TAX_ABNORMALOPERATION primary key (taxpayerid, taxcode, taxdatebegin, taxdateend, recno)
)
go

/*==============================================================*/
/* Table: TAX_MODELDEFINE                                       */
/*==============================================================*/
create table dbo.TAX_MODELDEFINE (
   modelid              varchar(4)           not null,
   modelname            varchar(200)         not null,
   totalitem            varchar(300)         not null,
   subtotalitem         varchar(300)         null,
   taxorgsupcode        varchar(11)          not null,
   taxorgcode           varchar(11)          not null,
   taxdeptcode          varchar(11)          not null,
   taxempcode           varchar(20)          not null,
   constraint PK_TAX_MODELDEFINE primary key (modelid)
)
go

/*==============================================================*/
/* Table: TAX_NOTICEINFO                                        */
/*==============================================================*/
create table dbo.TAX_NOTICEINFO (
   taxpayerid           varchar(20)          not null,
   noticeno             varchar(200)         null,
   noticedaynum         int                  null,
   noticeprintnum       int                  null,
   paydate              datetime             null,
   payno                varchar(200)         null,
   paydaynum            int                  null,
   payprintnum          int                  null,
   notes                varchar(200)         null,
   constraint PK_TAX_NOTICEINFO primary key (taxpayerid)
)
go

/*==============================================================*/
/* Table: TAX_SOURCE_DISPOABLE                                  */
/*==============================================================*/
create table dbo.TAX_SOURCE_DISPOABLE (
   serialno             varchar(32)          not null,
   storeid              varchar(32)          null,
   estateid             varchar(32)          null,
   houseid              varchar(32)          null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   taxtypecode          varchar(6)           not null,
   taxcode              varchar(6)           not null,
   taxingamount         decimal(14,2)        not null,
   taxrate              decimal(14,6)        not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   deratetype           varchar(2)           null,
   deratereason         varchar(50)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          null,
   remark               varchar(400)         null,
   regflag              varchar(2)           not null,
   landtaxflag          varchar(2)           null,
   taxflag              varchar(2)           not null,
   producedate          datetime             not null,
   useflag              varchar(2)           not null,
   ownflag              varchar(2)           not null,
   derateflag           varchar(2)           not null,
   validflag            varchar(2)           not null,
   constraint PK_TAX_SOURCE_DISPOABLE primary key (serialno)
)
go

/*==============================================================*/
/* Index: Index_estateid                                        */
/*==============================================================*/
create index Index_estateid on dbo.TAX_SOURCE_DISPOABLE (
estateid ASC
)
go

/*==============================================================*/
/* Index: Index_taxpayerid                                      */
/*==============================================================*/
create index Index_taxpayerid on dbo.TAX_SOURCE_DISPOABLE (
taxpayerid ASC
)
go

/*==============================================================*/
/* Table: TAX_SOURCE_ESTATE                                     */
/*==============================================================*/
create table dbo.TAX_SOURCE_ESTATE (
   serialno             varchar(32)          not null,
   estateid             varchar(32)          not null,
   estateserialno       varchar(30)          null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   taxrate              decimal(14,6)        not null,
   landarea             decimal(14,2)        not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   transmoney           decimal(14,2)        null,
   deratetype           varchar(2)           null,
   deratereason         varchar(50)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          null,
   remark               varchar(400)         null,
   regflag              varchar(2)           not null,
   landtaxflag          varchar(2)           null,
   taxflag              varchar(2)           not null,
   producedate          datetime             not null,
   useflag              varchar(2)           not null,
   ownflag              varchar(2)           not null,
   derateflag           varchar(2)           not null,
   validflag            varchar(2)           not null,
   constraint PK_TAX_SOURCE_ESTATE primary key (serialno)
)
go

/*==============================================================*/
/* Index: idx_estateid                                          */
/*==============================================================*/
create index idx_estateid on dbo.TAX_SOURCE_ESTATE (
estateid ASC
)
go

/*==============================================================*/
/* Index: Index_taxpayerid                                      */
/*==============================================================*/
create index Index_taxpayerid on dbo.TAX_SOURCE_ESTATE (
taxpayerid ASC
)
go

/*==============================================================*/
/* Index: Index_taxdate                                         */
/*==============================================================*/
create index Index_taxdate on dbo.TAX_SOURCE_ESTATE (
taxdatebegin ASC,
taxdateend ASC
)
go

/*==============================================================*/
/* Index: landsource_businessnumber                             */
/*==============================================================*/
create index landsource_businessnumber on dbo.TAX_SOURCE_ESTATE (
businessnumber ASC
)
go

/*==============================================================*/
/* Table: TAX_SOURCE_HOUSE                                      */
/*==============================================================*/
create table dbo.TAX_SOURCE_HOUSE (
   serialno             varchar(32)          not null,
   houseid              varchar(32)          not null,
   estateserialno       varchar(30)          null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   housetaxoriginalvalue decimal(14,2)        not null,
   rateoftaxable        decimal(14,2)        not null,
   houseresidualvalue   decimal(14,2)        not null,
   transmoney           decimal(14,2)        null,
   housearea            decimal(14,2)        not null,
   deratetype           varchar(2)           null,
   deratereason         varchar(50)          null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   businesscode         varchar(6)           not null,
   businessnumber       varchar(60)          not null,
   regflag              varchar(2)           not null,
   remark               varchar(400)         null,
   taxflag              varchar(2)           not null,
   useflag              varchar(2)           not null,
   ownflag              varchar(2)           not null,
   derateflag           varchar(2)           not null,
   hireflag             varchar(2)           not null,
   housetaxflag         varchar(2)           not null,
   valid                varchar(2)           not null,
   constraint PK_TAX_SOURCE_HOUSE primary key (serialno)
)
go

/*==============================================================*/
/* Index: housesource_busnumber                                 */
/*==============================================================*/
create index housesource_busnumber on dbo.TAX_SOURCE_HOUSE (
businessnumber ASC
)
go

/*==============================================================*/
/* Table: TAX_SOURCE_PLOUGH                                     */
/*==============================================================*/
create table dbo.TAX_SOURCE_PLOUGH (
   serialno             varchar(32)          not null,
   ploughid             varchar(32)          not null,
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   ploughtaxarea        decimal(14,2)        not null,
   deratetype           varchar(2)           null,
   deratereason         varchar(50)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   optorgcode           varchar(11)          null,
   optempcode           varchar(20)          null,
   businesscode         varchar(6)           not null,
   businessid           varchar(60)          null,
   remark               varchar(400)         null,
   ploughtaxflag        varchar(2)           null,
   taxflag              varchar(2)           not null,
   producedate          datetime             not null,
   derateflag           varchar(2)           not null,
   validflag            varchar(2)           not null,
   belongtocountrycode  varchar(10)          null,
   constraint PK_TAX_SOURCE_PLOUGH primary key (serialno)
)
go

/*==============================================================*/
/* Table: TAX_TAXABILITY                                        */
/*==============================================================*/
create table dbo.TAX_TAXABILITY (
   serialno             varchar(32)          not null,
   sourceid             varchar(32)          not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   taxtypecode          varchar(6)           not null,
   taxcode              varchar(6)           not null,
   taxingamount         decimal(14,2)        not null,
   taxingquantity       decimal(14,2)        not null,
   taxrate              decimal(14,6)        not null,
   taxamount            decimal(14,2)        not null,
   taxamountactual      decimal(14,2)        not null,
   deratetype           varchar(2)           null,
   deratereason         varchar(50)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   derateflag           varchar(2)           not null,
   status               varchar(1)           not null,
   taxamountpaid        decimal(14,2)        null,
   state                varchar(2)           null,
   constraint PK_TAX_TAXABILITY primary key (serialno)
)
go

/*==============================================================*/
/* Index: sourceid_shouldtaxmain                                */
/*==============================================================*/
create index sourceid_shouldtaxmain on dbo.TAX_TAXABILITY (
sourceid ASC
)
go

/*==============================================================*/
/* Table: TAX_TAXABILITYSUB                                     */
/*==============================================================*/
create table dbo.TAX_TAXABILITYSUB (
   serialno             varchar(32)          not null,
   recno                int                  not null,
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   taxtypecode          varchar(6)           not null,
   taxcode              varchar(6)           not null,
   taxingamount         decimal(14,2)        not null,
   taxingquantity       decimal(14,2)        not null,
   taxrate              decimal(14,6)        not null,
   taxamount            decimal(14,2)        not null,
   taxamountactual      decimal(14,2)        not null,
   taxdatebegin         datetime             not null,
   taxdateend           datetime             not null,
   levydatetype         varchar(2)           not null,
   paydate              datetime             null,
   taxyear              varchar(10)          null,
   taxmonth             varchar(10)          null,
   taxquarter           varchar(10)          null,
   taxhalf              varchar(10)          null,
   clearlogid           varchar(32)          null,
   cleardetailid        varchar(32)          null,
   logmainid            varchar(32)          null,
   taxstate             varchar(2)           null,
   taxamountpaid        decimal(14,2)        null,
   state                varchar(2)           null,
   sourceid             varchar(32)          null,
   taxorgsupcode        varchar(11)          null,
   taxorgcode           varchar(11)          null,
   taxdeptcode          varchar(11)          null,
   taxmanagercode       varchar(20)          null,
   derateflag           varchar(2)           null,
   constraint PK_TAX_TAXABILITYSUB primary key (serialno, recno)
)
go

/*==============================================================*/
/* Index: index_taxpayerid                                      */
/*==============================================================*/
create index index_taxpayerid on dbo.TAX_TAXABILITYSUB (
taxpayerid ASC
)
go

/*==============================================================*/
/* Index: Index_taxdate                                         */
/*==============================================================*/
create index Index_taxdate on dbo.TAX_TAXABILITYSUB (
taxdatebegin ASC,
taxdateend ASC
)
go

/*==============================================================*/
/* Index: Index_taxcode                                         */
/*==============================================================*/
create index Index_taxcode on dbo.TAX_TAXABILITYSUB (
taxcode ASC
)
go

/*==============================================================*/
/* Index: sourceid_shouldtaxsub                                 */
/*==============================================================*/
create index sourceid_shouldtaxsub on dbo.TAX_TAXABILITYSUB (
sourceid ASC
)
go

/*==============================================================*/
/* Table: TEMP_CHURANG                                          */
/*==============================================================*/
create table dbo.TEMP_CHURANG (
   no                   varchar(100)         null,
   pno                  varchar(100)         null,
   adress               varchar(100)         null,
   area1                varchar(100)         null,
   area2                varchar(100)         null,
   type                 varchar(100)         null,
   year                 varchar(100)         null,
   selltype             varchar(100)         null,
   optdatebegin         varchar(100)         null,
   optdateend           varchar(100)         null,
   optdate              varchar(100)         null,
   sumprice             varchar(100)         null,
   price1               varchar(100)         null,
   price2               varchar(100)         null,
   price3               varchar(100)         null,
   price4               varchar(100)         null,
   price5               varchar(100)         null,
   price6               varchar(100)         null,
   price7               varchar(100)         null,
   price8               varchar(100)         null,
   name                 varchar(100)         null,
   person               varchar(100)         null,
   personadress         varchar(100)         null,
   phone                varchar(100)         null,
   paydate              varchar(100)         null,
   shenju_no            varchar(100)         null,
   shenju_date          varchar(100)         null,
   shiju_no             varchar(100)         null,
   shiju_date           varchar(100)         null,
   xianju_no            varchar(100)         null,
   xianju_date          varchar(100)         null,
   guihua_no            varchar(100)         null,
   guihua_date          varchar(100)         null,
   guihua_fujian        varchar(100)         null,
   guihua_xingzhi       varchar(100)         null,
   guihua_rongjilv      varchar(100)         null,
   guihua_lvdilv        varchar(100)         null,
   guihua_jianzhumidu   varchar(100)         null,
   guihua_jianzhuxiangao varchar(100)         null,
   guihua_fujian2       varchar(100)         null,
   guanwiehui_no        varchar(100)         null,
   guanwiehui_date      varchar(100)         null
)
go

/*==============================================================*/
/* Table: TEMP_PIFU                                             */
/*==============================================================*/
create table dbo.TEMP_PIFU (
   taxregion            varchar(100)         null,
   name                 varchar(100)         null,
   type                 varchar(100)         null,
   no                   varchar(100)         null,
   area                 varchar(100)         null,
   optdate              varchar(100)         null,
   optemp               varchar(100)         null,
   flag                 varchar(100)         null,
   year                 varchar(100)         null,
   pic                  varchar(100)         null
)
go

/*==============================================================*/
/* Table: TMP_GROUND                                            */
/*==============================================================*/
create table dbo.TMP_GROUND (
   uuid                 varchar(32)          not null,
   groundid             varchar(20)          not null,
   taxpayerid           varchar(20)          not null,
   groundaddress        varchar(200)         not null,
   groundarea           decimal(16,2)        not null,
   gathertype           varchar(2)           not null,
   constraint uuid primary key nonclustered (uuid)
)
go

/*==============================================================*/
/* Table: T_RULEINFO                                            */
/*==============================================================*/
create table dbo.T_RULEINFO (
   rulekey              varchar(50)          not null,
   ruledescription      varchar(100)         null,
   ruletype             varchar(20)          null,
   rulexml              varchar(3500)        not null,
   bpmnxml              varchar(3500)        null,
   notes                varchar(500)         null,
   constraint PK_T_RULEINFO primary key nonclustered (rulekey)
)
go

/*==============================================================*/
/* Table: finalcheck                                            */
/*==============================================================*/
create table dbo.finalcheck (
   taxpayerid           varchar(11)          not null,
   constraint id primary key nonclustered (taxpayerid)
)
go

/*==============================================================*/
/* Table: notfinalcheckestate                                   */
/*==============================================================*/
create table dbo.notfinalcheckestate (
   estateid             varchar(32)          not null,
   state                int                  not null
)
go

/*==============================================================*/
/* Table: pbcatcol                                              */
/*==============================================================*/
create table dbo.pbcatcol (
   pbc_tnam             char(30)             not null,
   pbc_tid              int                  not null,
   pbc_ownr             char(30)             not null,
   pbc_cnam             char(30)             not null,
   pbc_cid              smallint             not null,
   pbc_labl             varchar(254)         null,
   pbc_lpos             smallint             null,
   pbc_hdr              varchar(254)         null,
   pbc_hpos             smallint             null,
   pbc_jtfy             smallint             null,
   pbc_mask             varchar(31)          null,
   pbc_case             smallint             null,
   pbc_hght             smallint             null,
   pbc_wdth             smallint             null,
   pbc_ptrn             varchar(31)          null,
   pbc_bmap             char(1)              null,
   pbc_init             varchar(254)         null,
   pbc_cmnt             varchar(254)         null,
   pbc_edit             varchar(31)          null,
   pbc_tag              varchar(254)         null
)
go

/*==============================================================*/
/* Index: pbcatcol_idx                                          */
/*==============================================================*/
create unique index pbcatcol_idx on dbo.pbcatcol (
pbc_tid ASC,
pbc_cid ASC
)
go

/*==============================================================*/
/* Table: pbcatedt                                              */
/*==============================================================*/
create table dbo.pbcatedt (
   pbe_name             varchar(30)          not null,
   pbe_edit             varchar(254)         not null,
   pbe_type             smallint             not null,
   pbe_cntr             int                  null,
   pbe_seqn             smallint             not null,
   pbe_flag             int                  null,
   pbe_work             char(32)             null
)
go

/*==============================================================*/
/* Index: pbcatedt_idx                                          */
/*==============================================================*/
create unique clustered index pbcatedt_idx on dbo.pbcatedt (
pbe_name ASC,
pbe_seqn ASC
)
go

/*==============================================================*/
/* Table: pbcatfmt                                              */
/*==============================================================*/
create table dbo.pbcatfmt (
   pbf_name             varchar(30)          not null,
   pbf_frmt             varchar(254)         not null,
   pbf_type             smallint             not null,
   pbf_cntr             int                  null
)
go

/*==============================================================*/
/* Index: pbcatfmt_idx                                          */
/*==============================================================*/
create unique index pbcatfmt_idx on dbo.pbcatfmt (
pbf_name ASC
)
go

/*==============================================================*/
/* Table: pbcattbl                                              */
/*==============================================================*/
create table dbo.pbcattbl (
   pbt_tnam             char(30)             not null,
   pbt_tid              int                  not null,
   pbt_ownr             char(30)             not null,
   pbd_fhgt             smallint             null,
   pbd_fwgt             smallint             null,
   pbd_fitl             char(1)              null,
   pbd_funl             char(1)              null,
   pbd_fchr             smallint             null,
   pbd_fptc             smallint             null,
   pbd_ffce             char(32)             null,
   pbh_fhgt             smallint             null,
   pbh_fwgt             smallint             null,
   pbh_fitl             char(1)              null,
   pbh_funl             char(1)              null,
   pbh_fchr             smallint             null,
   pbh_fptc             smallint             null,
   pbh_ffce             char(32)             null,
   pbl_fhgt             smallint             null,
   pbl_fwgt             smallint             null,
   pbl_fitl             char(1)              null,
   pbl_funl             char(1)              null,
   pbl_fchr             smallint             null,
   pbl_fptc             smallint             null,
   pbl_ffce             char(32)             null,
   pbt_cmnt             varchar(254)         null
)
go

/*==============================================================*/
/* Index: pbcattbl_idx                                          */
/*==============================================================*/
create unique index pbcattbl_idx on dbo.pbcattbl (
pbt_tid ASC
)
go

/*==============================================================*/
/* Table: pbcatvld                                              */
/*==============================================================*/
create table dbo.pbcatvld (
   pbv_name             varchar(30)          not null,
   pbv_vald             varchar(254)         not null,
   pbv_type             smallint             not null,
   pbv_cntr             int                  null,
   pbv_msg              varchar(254)         null
)
go

/*==============================================================*/
/* Index: pbcatvld_idx                                          */
/*==============================================================*/
create unique clustered index pbcatvld_idx on dbo.pbcatvld (
pbv_name ASC
)
go

/*==============================================================*/
/* Table: t                                                     */
/*==============================================================*/
create table dbo.t (
   estateid             varchar(32)          not null,
   housearea            decimal(14,2)        not null,
   amount               decimal(14,2)        not null,
   constraint id primary key nonclustered (estateid)
)
go

/*==============================================================*/
/* Table: t1                                                    */
/*==============================================================*/
create table dbo.t1 (
   taxpayerid           varchar(20)          not null,
   taxpayername         varchar(100)         not null,
   taxarea              decimal(14,2)        not null default 0,
   levarea              decimal(14,2)        not null default 0
)
go

/*==============================================================*/
/* Table: t2                                                    */
/*==============================================================*/
create table dbo.t2 (
   taxpayerid           varchar(20)          null,
   taxpayername         varchar(100)         null,
   levamount            decimal(14,2)        not null default 0.00
)
go

/*==============================================================*/
/* Table: tmp                                                   */
/*==============================================================*/
create table dbo.tmp (
   smid                 int                  not null,
   objectid             int                  not null,
   constraint id primary key nonclustered (smid)
)
go

/*==============================================================*/
/* Table: ttt                                                   */
/*==============================================================*/
create table dbo.ttt (
   id                   varchar(50)          not null,
   d                    varchar(50)          not null
)
go

