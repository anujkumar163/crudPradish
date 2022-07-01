public int i = 0;
	final static Logger log = Logger.getLogger(SubscriptionController.class);

	@RequestMapping(value = "in", method = RequestMethod.GET)
	public ModelAndView index(@RequestParam(value = "username", required = false) String username,
			@RequestParam(value = "password", required = false) String password, ModelAndView modelAndView,
			HttpServletRequest request, HttpSession session) throws IOException, GeoIp2Exception {

		return index(username, password, modelAndView, request, session, "in");
	}

	@RequestMapping(value = "", method = RequestMethod.GET)
	public ModelAndView index2(@RequestParam(value = "username", required = false) String username,
			@RequestParam(value = "password", required = false) String password, ModelAndView modelAndView,
			HttpServletRequest request, HttpSession session) throws IOException, GeoIp2Exception {
		return index(username, password, modelAndView, request, session, null);
	}

	public ModelAndView index(String username, String password, ModelAndView modelAndView, HttpServletRequest request,
			HttpSession session, String country) throws IOException, GeoIp2Exception {
		System.out.println(username);
		if (username != null) {
			UserDetails userDetails = null;
			System.out.println("inside if user is a valid json.");
			try {
				userDetails = userDetailsService.loadUserByUsername(username);
			} catch (Exception e) {
				e.printStackTrace();
				// logger.error("Authentication Failed. Username not found.");
			}

			if (userDetails != null) {
				Registration registration = registrationService.findRegistrationByUsername(username);
				// Student student = studentService.findByStudentCode(user.getUsername());

				UsernamePasswordAuthenticationToken authentication = null;
				if (registration != null && password != null && registration.getPassword() != null
						&& passwordEncoder.matches(password, registration.getPassword())) {
					authentication = new UsernamePasswordAuthenticationToken(userDetails, null,
							Arrays.asList(new SimpleGrantedAuthority("ROLE_PARENT")));
				}

				if (authentication != null) {
					authentication.setDetails(new CustomWebAuthenticationDetails(request));
					SecurityContextHolder.getContext().setAuthentication(authentication);
					session.setAttribute("registrationId", registration.getId());
					modelAndView.setViewName("redirect:/purchase-pie");
					return modelAndView;
				}

			}
		}

		System.out.println("Inside index....");
		Integer isLogin = 0;

		if (request.getParameter("isLogin") != null && !request.getParameter("isLogin").equals("")) {
			isLogin = Integer.parseInt(request.getParameter("isLogin"));
			if (isLogin != 0) {
				modelAndView.addObject("isLogin", isLogin);
			}
		}
		Integer isRegistration = 0;
		if (request.getParameter("isRegistration") != null && !request.getParameter("isRegistration").equals("")) {
			isRegistration = Integer.parseInt(request.getParameter("isRegistration"));
			if (isRegistration != 0) {
				modelAndView.addObject("isRegistration", isRegistration);
			}
		}
		String url = ((HttpServletRequest) request).getRequestURL().toString();
		String url1 = request.getContextPath();

		// System.out.println("country 11:" + country);
		if (country != null && country.equalsIgnoreCase("in")) {
			session.setAttribute("country", "in");
		} else {
			if (!environment.equals("local") && request instanceof HttpServletRequest) {
				com.praadis.edu.util.GetLocationExample loc = new com.praadis.edu.util.GetLocationExample();
				if (!loc.getLocation1(getClientIp(request)).getCountryCode().equals("IN") && !url.contains("/us/")
						&& !url.contains("/us") && !url.contains("/assets/")) {
					modelAndView.setViewName("redirect:/us");
					return modelAndView;
				} else {
					System.out.println(country);
					session.setAttribute("country", "in");
				}
			} else {
				session.setAttribute("country", "in");
			}
		}
		modelAndView.setViewName("kids_app");
		return modelAndView;
	}

	private static String getClientIp(HttpServletRequest request) {
		String remoteAddr = "";
		if (request != null) {
			remoteAddr = request.getHeader("X-FORWARDED-FOR");
			if (remoteAddr == null || "".equals(remoteAddr)) {
				remoteAddr = request.getRemoteAddr();
			}
		}

		return remoteAddr;
	}

	@RequestMapping(value = "index_test", method = RequestMethod.GET)
	public ModelAndView indexTest(ModelAndView modelAndView, HttpServletRequest request, HttpSession session) {

		System.out.println("Inside index....");
		Integer isLogin = 0;
		if (request.getParameter("isLogin") != null && !request.getParameter("isLogin").equals("")) {
			isLogin = Integer.parseInt(request.getParameter("isLogin"));
		}
		Integer isRegistration = 0;
		if (request.getParameter("isRegistration") != null && !request.getParameter("isRegistration").equals("")) {
			isRegistration = Integer.parseInt(request.getParameter("isRegistration"));
		}
		modelAndView.addObject("isRegistration", isRegistration);
		modelAndView.addObject("isLogin", isLogin);
		modelAndView.setViewName("indexTest");
		return modelAndView;
	}

	@ModelAttribute
	public void addAttributes(ModelAndView modelAndView) {
		try {
			i++;
			System.out.println("Index har baar call hounga" + i);
			modelAndView.addObject("countries", countryService.findAll());
			modelAndView.addObject("schoolClasses", schoolClassService.findAll());
			modelAndView.addObject("appCountries", appCountryService.findAll());
			// System.out.println(appCountryService.findAll());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@RequestMapping(value = { "products" }, method = RequestMethod.GET)
	public ModelAndView products(ModelAndView modelAndView) {
		System.out.println("inside web products");
		modelAndView.setViewName("products");
		modelAndView.addObject("activeClass", "products");
		return modelAndView;
	}

	@RequestMapping(value = "about-us", method = RequestMethod.GET)
	public ModelAndView aboutus_kids(ModelAndView modelAndView, HttpSession session) {
		System.out.println("inside web aboutus child");
		modelAndView.setViewName("aboutus_child");
		modelAndView.addObject("activeClass", "aboutus_child");
		return modelAndView;
	}

	@RequestMapping(value = "liveVideos", method = RequestMethod.GET)

	public ModelAndView liveVideos(ModelAndView modelAndView, HttpServletRequest request, HttpSession session) {
		// if (session != null && session.getAttribute("registrationId") != null) {
		System.out.println("inside ui liveVideos ");
		System.out.println("inside ui controller method name live-videos");
		// modelAndView.setViewName("video-player");
		Integer dateresult = null;
		Registration registration = registrationService.findById((Integer) session.getAttribute("registrationId"));
		System.out.println("registration " + registration);
		Integer packageTypeId = 1;
		RegistrationPackage registrationPackage = registrationPackageService
				.findByRegistration_IdAndPackageType_Id(registration.getId(), packageTypeId);

		System.out.println("Class Name  " + registrationPackage);
		Map<String, String> list = new HashMap<String, String>();
		Map<String, String> map = new HashMap<String, String>();
		if (registrationPackage != null) {
			map.put("schoolClass", registrationPackage.getAppPackage().getSchoolClass().getName());
			map.put("apackage", registrationPackage.getAppPackage().getName());
			map.put("ptype", registrationPackage.getPurchaseType());
			map.put("eDate", registrationPackage.getExpiryDate().toString());
			map.put("name", registration.getName());
			map.put("userName", registration.getUsername());
			list.putAll(map);

			System.out.println("school class name--" + registration.getName());

			Date currentSqlDate = Calendar.getInstance().getTime();
			DateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
			String today = formatter.format(currentSqlDate);
			try {
				Date date1 = formatter.parse(today);
				Date date2 = formatter.parse(registrationPackage.getExpiryDate().toString());
				dateresult = date1.compareTo(date2);

			} catch (Exception e) {
				// TODO: handle exception
				System.out.println("date not working-" + e);
			}

			if (registrationPackage.getPurchaseType().equalsIgnoreCase(PurchaseType.PAID.toString())
					&& dateresult < 1) {
				modelAndView.addObject("list", list);
				modelAndView.addObject("classname", "12");
				modelAndView.setViewName("video-player");
			} else {
				System.out.println("else not running ");
				modelAndView.addObject("purchaseMsg", "0");
				modelAndView.setViewName("redirect:/purchase-pie");
			}
		} else {
			modelAndView.setViewName("redirect:/purchase-pie");
		}
		return modelAndView;
	}

	/*
	 * // zoom video player code start here
	 * 
	 * 
	 * 
	 * // zoom genetate signature >>>>>>>>>>>>>
	 * 
	 * public static String generateSignature(String apiKey, String apiSecret,
	 * String meetingNumber, Integer role) { try { Mac hasher =
	 * Mac.getInstance("HmacSHA256"); String ts =
	 * Long.toString(System.currentTimeMillis() - 30000); String msg =
	 * String.format("%s%s%s%d", apiKey, meetingNumber, ts, role);
	 * 
	 * hasher.init(new SecretKeySpec(apiSecret.getBytes(), "HmacSHA256"));
	 * 
	 * String message = Base64.getEncoder().encodeToString(msg.getBytes()); byte[]
	 * hash = hasher.doFinal(message.getBytes());
	 * 
	 * String hashBase64Str = DatatypeConverter.printBase64Binary(hash); String
	 * tmpString = String.format("%s.%s.%s.%d.%s", apiKey, meetingNumber, ts, role,
	 * hashBase64Str); String encodedString =
	 * Base64.getEncoder().encodeToString(tmpString.getBytes());
	 * 
	 * return encodedString.replaceAll("\\=+$", "");
	 * 
	 * } catch (NoSuchAlgorithmException e) { } catch (InvalidKeyException e) { }
	 * return ""; }
	 * 
	 * // zoom genetate signature end>>>>>>>>>>>>>>>>
	 * 
	 * @GetMapping("new_chat_module") public ModelAndView newChatModule(ModelAndView
	 * modelAndView, HttpSession session) { try {
	 * System.out.println("index chat for zoom player"); Integer id = (Integer)
	 * session.getAttribute("registrationId"); Registration regname =
	 * registrationService.findById(id);
	 * modelAndView.addObject("username",regname.getUsername());
	 * modelAndView.addObject("roomId",session.getAttribute("zoomRoomId"));
	 * modelAndView.setViewName("chat_new"); } catch (Exception e) {
	 * e.printStackTrace(); }
	 * 
	 * return modelAndView; }
	 * 
	 * @GetMapping("new_chat_exam") public ModelAndView
	 * newChatExamModule(ModelAndView modelAndView, HttpSession session) { try {
	 * System.out.println("ajax chat exam working"); Integer id = (Integer)
	 * session.getAttribute("registrationId"); Registration regname =
	 * registrationService.findById(id);
	 * modelAndView.addObject("username",regname.getUsername());
	 * modelAndView.addObject("roomId",session.getAttribute("zoomRoomId"));
	 * modelAndView.setViewName("chat_exam_module"); } catch (Exception e) {
	 * e.printStackTrace(); }
	 * 
	 * return modelAndView; }
	 * 
	 * 
	 * // new zoom player live videos mapping >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	 * 
	 * @RequestMapping(value = "zoom-videos", method = RequestMethod.POST) public
	 * ModelAndView zoomVideos(ModelAndView modelAndView, HttpSession
	 * session,HttpServletRequest request) {
	 * 
	 * String zoomMeetingId = request.getParameter("zoomMeetingId"); String
	 * zoomPassword = request.getParameter("zoomPassword");
	 * System.out.println("zoomMeetingId "+zoomMeetingId);
	 * System.out.println("zoomPassword "+zoomPassword);
	 * System.out.println("inside web zoom-videos");
	 * 
	 * System.out.println("inside index controller method name zoom-videos");
	 * 
	 * if (session != null && session.getAttribute("registrationId") != null) {
	 * System.out.println("zoomMeetingId " + zoomMeetingId);
	 * System.out.println("zoomPassword " + zoomPassword); if(zoomMeetingId != null
	 * && zoomPassword != null && !zoomMeetingId.isEmpty() &&
	 * !zoomPassword.isEmpty()) { session.setAttribute("zoomRoomId", zoomMeetingId);
	 * String apiKey = "-GKqdXm1QuOEVz6e4e9Z0w"; String apiSecret =
	 * "pjC9T1YaRbKPChUDAOPbdySbjReNOuJbJui0"; String meetingNumber = zoomMeetingId;
	 * String meetingPassword = zoomPassword; String signature =
	 * generateSignature(apiKey, apiSecret, meetingNumber, 0);
	 * System.out.println("signature>>>>" + signature);
	 * modelAndView.addObject("meetingNumber", meetingNumber);
	 * modelAndView.addObject("meetingPassword", meetingPassword);
	 * modelAndView.addObject("apiKey", apiKey); modelAndView.addObject("apiSecret",
	 * apiSecret); modelAndView.addObject("signature", signature);
	 * modelAndView.setViewName("zoom-player");
	 * 
	 * } else { System.out.println("else running ni jane dunga andr");
	 * modelAndView.addObject("noStream", "0");
	 * modelAndView.setViewName("redirect:/liveVideos"); }
	 * 
	 * // return modelAndView;
	 * 
	 * //}
	 * 
	 * //modelAndView.setViewName("redirect:/"); return modelAndView; }
	 * 
	 * 
	 * 
	 * // new zoom player live videos mapping end >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	 * 
	 */

//  zoom video player code end here	

	@RequestMapping(value = "thank-you", method = RequestMethod.GET)
	public ModelAndView thankYou(ModelAndView modelAndView) {
		System.out.println("inside thank you");
		modelAndView.setViewName("thankyou");
		return modelAndView;
	}

	@RequestMapping(value = "contact-us", method = RequestMethod.GET)
	public ModelAndView contactus_kids(ModelAndView modelAndView, HttpSession session, ContactUs contactUs) {
		System.out.println("inside web contactus kids");
		modelAndView.setViewName("contactus_kids");
		modelAndView.addObject("contactUs", contactUs);
		modelAndView.addObject("activeClass", "contactus_kids");
		return modelAndView;
	}

	/*
	 * @RequestMapping(value = "terms-and-conditions", method = RequestMethod.GET)
	 * public ModelAndView getTermsAndConditionExceptUsa(ModelAndView modelAndView,
	 * HttpSession session) {
	 * System.out.println("inside web term_and_condition_except_usa");
	 * modelAndView.setViewName("term_and_condition_except_usa");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 */

	@RequestMapping(value = "features", method = RequestMethod.GET)
	public ModelAndView paymentWebGET(ModelAndView modelAndView) {
		System.out.println("inside payment web feature..");
		modelAndView.setViewName("feature");
		return modelAndView;
	}

	/*
	 * @RequestMapping(value = "terms-and-conditions", method = RequestMethod.GET)
	 * public ModelAndView termsAndconditions_kids(ModelAndView modelAndView,
	 * HttpSession session) {
	 * System.out.println("inside web terms&conditions_kids");
	 * modelAndView.setViewName("terms&conditions_kids");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "term-and-condition-usa", method = RequestMethod.GET)
	 * public ModelAndView getTermsAndConditionUsa(ModelAndView modelAndView,
	 * HttpSession session) {
	 * System.out.println("inside web term-and-condition-usa");
	 * modelAndView.setViewName("term-and-condition-usa");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 *
	 * @RequestMapping(value = "terms-and-condition-except-usa", method =
	 * RequestMethod.GET) public ModelAndView
	 * getTermsAndConditionExceptUsa(ModelAndView modelAndView, HttpSession session)
	 * { System.out.println("inside web term_and_condition_except_usa");
	 * modelAndView.setViewName("term_and_condition_except_usa");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "privacy-policy", method = RequestMethod.GET) public
	 * ModelAndView privacy_policy_kids(ModelAndView modelAndView) {
	 * System.out.println("inside web privacy_policy_kids");
	 * modelAndView.setViewName("privacy_policy_kids");
	 * modelAndView.addObject("activeClass", "privacy_policy_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "privacy-policy-usa", method = RequestMethod.GET)
	 * public ModelAndView getPrivacyPolicyUsa(ModelAndView modelAndView,
	 * HttpSession session) { System.out.println("inside web privacy-policy-usa");
	 * modelAndView.setViewName("privacy-policy-usa");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "privacy-policy-except-usa", method =
	 * RequestMethod.GET) public ModelAndView
	 * getPricayAndPolicyExceptUsa(ModelAndView modelAndView, HttpSession session) {
	 * System.out.println("inside web privacy-policy-except-usa");
	 * modelAndView.setViewName("privacy-policy-except-usa");
	 * modelAndView.addObject("activeClass", "terms_and_conditions_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "disclaimer", method = RequestMethod.GET) public
	 * ModelAndView disclaimer_kids(ModelAndView modelAndView) {
	 * System.out.println("inside web disclaimer_kids");
	 * modelAndView.setViewName("disclaimer_kids");
	 * modelAndView.addObject("activeClass", "disclaimer_kids"); return
	 * modelAndView; }
	 * 
	 * @RequestMapping(value = "help", method = RequestMethod.GET) public
	 * ModelAndView help_kids(ModelAndView modelAndView) {
	 * System.out.println("inside web help_kids");
	 * modelAndView.setViewName("help_kids"); modelAndView.addObject("activeClass",
	 * "help_kids"); return modelAndView; }
	 * 
	 * @RequestMapping(value = "guide", method = RequestMethod.GET) public
	 * ModelAndView guide(ModelAndView modelAndView) {
	 * System.out.println("inside web guide"); modelAndView.setViewName("guide");
	 * modelAndView.addObject("activeClass", "guide"); return modelAndView; }
	 * 
	 * @RequestMapping(value = "tour", method = RequestMethod.GET) public
	 * ModelAndView tour(ModelAndView modelAndView) {
	 * System.out.println("inside web tour"); modelAndView.setViewName("tour");
	 * modelAndView.addObject("activeClass", "tour"); return modelAndView; }
	 * 
	 * @RequestMapping(value = { "site-map" }, method = RequestMethod.GET) public
	 * ModelAndView sitemap_kids(ModelAndView modelAndView) {
	 * System.out.println("inside web sitemap_kids");
	 * modelAndView.setViewName("sitemap_kids");
	 * modelAndView.addObject("activeClass", "sitemap_kids"); return modelAndView; }
	 * 
	 * @RequestMapping(value = "request-a-demo", method = RequestMethod.GET) public
	 * ModelAndView request_a_demo_kids(ModelAndView modelAndView, RequestDemo
	 * requestDemo) { System.out.println("inside web request_a_demo_kids");
	 * modelAndView.setViewName("request_a_demo_kids");
	 * modelAndView.addObject("requestDemo", requestDemo);
	 * modelAndView.addObject("activeClass", "request_a_demo_kids"); return
	 * modelAndView; }
	 */

	@RequestMapping(value = { "site-map" }, method = RequestMethod.GET)
	public ModelAndView sitemap_kids(ModelAndView modelAndView, HttpSession session) {
		System.out.println("inside web sitemap_kids");
		session.setAttribute("country", "in");
		modelAndView.setViewName("sitemap_kids");
		modelAndView.addObject("activeClass", "sitemap_kids");
		return modelAndView;
	}

	@RequestMapping(value = "kidslogin", method = RequestMethod.GET)
	public ModelAndView kidsLogin(ModelAndView modelAndView, HttpSession session) {
		System.out.println("child login page");
		session.setAttribute("country", "in");
		modelAndView.setViewName("login");
		return modelAndView;
	}

	@RequestMapping(value = "sales-inquiry", method = RequestMethod.GET)
	public ModelAndView sales_inquiry_6to12(ModelAndView modelAndView, SalesInquiry salesInquiry) {

		System.out.println("inside web sales_inquiry_kids");
		modelAndView.setViewName("sales_inquiry_kids");

		try {

			modelAndView.addObject("workplaces", workplaceService.findAll());
			modelAndView.addObject("states", stateService.findAll());
			modelAndView.addObject("appCountry", countryService.findAll());

		} catch (Exception e) {
			e.printStackTrace();
		}

		modelAndView.addObject("salesInquiry", salesInquiry);
		modelAndView.addObject("activeClass", "sales_inquiry_6to12");

		return modelAndView;
	}

	@RequestMapping(value = "request-a-demo", method = RequestMethod.GET)
	public ModelAndView requestUs(ModelAndView modelAndView) {
		System.out.println("inside web request a demo us");
		modelAndView.setViewName("request_a_demo_kids");
		modelAndView.addObject("activeClass", "request");
		return modelAndView;
	}

	@RequestMapping(value = "customer-support", method = RequestMethod.GET)
	public ModelAndView customer_support_kids(ModelAndView modelAndView, CustomerSupport customerSupport) {
		System.out.println("inside web customer_support_kids");
		modelAndView.setViewName("customer_support_kids");

		try {
			modelAndView.addObject("states", stateService.findAll());
			modelAndView.addObject("appCountry", countryService.findAll());
		} catch (Exception e) {
			e.printStackTrace();
		}

		modelAndView.addObject("customerSupport", customerSupport);
		modelAndView.addObject("activeClass", "customer_support_6to12");
		return modelAndView;
	}

	@RequestMapping(value = "purchase-pie", method = RequestMethod.GET)
	public ModelAndView getpie_kids(ModelAndView modelAndView, HttpSession session, GenericResponse response,
			@RequestParam(value = "purchaseMsg", required = false) String purchaseMsg) {
		System.out.println("inside index controller web purchase pie kids");
		System.out.println("purchaseMsg " + purchaseMsg);
		modelAndView.addObject("purchaseMsg", purchaseMsg);
		List<AppCountry> appCountries = null;
		session.setAttribute("country", "in");
		try {
			appCountries = appCountryService.findAll();
			modelAndView.addObject("appCountries", appCountries);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.addObject("activeClass", "purchase-pie_kids");
		// return modelAndView;
		Object id = session.getAttribute("registrationId");
		if (id != null && !id.equals("")) {
			Registration r = regserv.findById(Integer.parseInt("" + id));
			PackageHistory packageHistory = null;
			packageHistory = packageHistoryService.findFirstByRegistration_IdAndLastSeenDesc(
					Integer.parseInt(session.getAttribute("registrationId").toString()));
			System.out.println("IDDDDDDD IDDDD " + r.getId());
			RegistrationPackage registrationPackage = registrationPackageService
					.findByRegistration_IdAndPackageType_Id(r.getId(), 1);
			if (registrationPackage == null) {
				Calendar cal = Calendar.getInstance();
				cal.add(Calendar.DATE, 7);

				Date date = dateUtility.convertDate(new Date());

				registrationPackage = new RegistrationPackage();
				registrationPackage.setCreatedAt(date);

				registrationPackage.setIsActive(StudentStatus.ACTIVE.getStatus());
				String registrationPackageCode = "STUDENT-" + commonUtility.generateStudentCode();
				registrationPackage.setTokenCode(registrationPackageCode);
				registrationPackage.setAccessToken(commonUtility.generateFreeStudentToken(registrationPackageCode, 7));
				registrationPackage.setExpiryDate(cal.getTime());
				registrationPackage.setPurchaseType(PurchaseType.FREE.getType());

				registrationPackage.setRegistration(r);

				AppPackage appPackage;
				if (r.getCountryCode().equals("91")) {
					appPackage = appPackageService.findByNameAndSchoolClassId("CBSE", 1);
				} else {
					appPackage = appPackageService.findByNameAndSchoolClassId("USA Curriculum", 5);
				}
				if (appPackage == null) {
					appPackage = appPackageService.findFirstByOrderById();
				}
				if (registrationPackageService.findByRegistration_IdAndPackageType_Id(r.getId(), 1) == null) {
					registrationPackage.setAppPackage(appPackage);
					registrationPackage.setPackageType(appPackage.getPackageType());
					registrationPackage = registrationPackageService.save(registrationPackage);

					registrationPackageCode = "STUDENT-" + registrationPackage.getId();
					registrationPackage.setTokenCode(registrationPackageCode);
					registrationPackage
							.setAccessToken(commonUtility.generateFreeStudentToken(registrationPackageCode, 7));
					registrationPackage = registrationPackageService.save(registrationPackage);
				}
			}
			if (r.getCountryCode().equals("91")) {
				return packages(r.getCountryCode(), "India",
						registrationPackage.getAppPackage().getSchoolClass().getName(),
						registrationPackage.getAppPackage().getName(),
						registrationPackage.getAppPackage().getSchoolClass().getId().toString(), modelAndView, session,
						response);
			} else {
				return packages(r.getCountryCode(), "USA",
						registrationPackage.getAppPackage().getSchoolClass().getName(),
						registrationPackage.getAppPackage().getName(),
						registrationPackage.getAppPackage().getSchoolClass().getId().toString(), modelAndView, session,
						response);
			}

		} else {
			return packages("91", "India", "", "", "", modelAndView, session, response);
		}
	}

	@RequestMapping(value = "packages", method = RequestMethod.GET)
	public ModelAndView packages(@RequestParam("countryCode") String countryCode,
			@RequestParam(value = "appCountry", required = false) String appCountry,
			@RequestParam(value = "schoolClass", required = false) String schoolClass,
			@RequestParam(value = "appPackage", required = false) String appPackage,
			@RequestParam(value = "schoolClassId", required = false) String schoolClassId, ModelAndView modelAndView,
			HttpSession session, GenericResponse response) {
		System.out.println(schoolClassId);
		session.setAttribute("country", "in");
		Integer registrationId = null;
		List<PackageTypeDto> packageTypes = null;
		String appCountryCode = null;
		List<OtherCountryPackage> countryPackages = null;
		List<RegistrationPackage> registrationPackages = null;
		Registration registration = null;
		try {
			packageTypes = packageTypeService.findByCountryCode2("91");

			for (PackageTypeDto dto1 : packageTypes) {
				for (AndroidPackageTypePrice androidPackageTypePrice : dto1.getAndroidPackageTypePriceList()) {
					System.out.println("Price  Pricee " + androidPackageTypePrice.getPrice());
				}
			}

			modelAndView.addObject("packageTypes", packageTypes);
			if (session != null && session.getAttribute("registrationId") != null) {
				registrationId = (Integer) session.getAttribute("registrationId");
				registration = registrationService.findById(registrationId);
				appCountryCode = registration.getCountryCode();
				response = registrationPackageService.getRegistrationPackageList(registrationId, response);
				if (response != null && response.getData() != null) {
					System.out.println("responseBean :" + response.getData().toString());
					RegistrationPackageResponseBean responseBean = (RegistrationPackageResponseBean) response.getData();
					System.out.println("responseBean :" + responseBean.toString());
					if (responseBean != null && responseBean.getRegistrationPackages() != null) {
						modelAndView.addObject("myPackages", responseBean.getRegistrationPackages());
						response = new GenericResponse();
						response = registrationPackageService.getAvailableRegistrationPackages(
								responseBean.getRegistrationPackages().get(0).getId(), response);
						if (response != null && response.getData() != null) {
							responseBean = (RegistrationPackageResponseBean) response.getData();
							if (responseBean != null && responseBean.getRegistrationPackage() != null) {
								modelAndView.addObject("availablePackages", responseBean.getPackageTypes());
							}
						}
					}
				}
			} else {
				if (appCountry != null) {
					appCountryCode = countryCode;
				}

			}
			System.out.println("inside without login appcountry code" + appCountry);
			registrationPackages = registrationPackageService.findByPaidRegistrationPackageId(registrationId);

			modelAndView.addObject("purchasedList", registrationPackages);

			countryPackages = otherCountryPackageService.findAll();
			SchoolClass sc = null;
			if (schoolClassId != null && !schoolClassId.isEmpty()) {
				System.out.println("schoolClassId schoolClassId"+schoolClassId);
				sc = schoolClassService.findById(Integer.parseInt(schoolClassId));
				System.out.println("sc :" + sc);

				AppPackage ap = appPackageService.findByNameAndSchoolClassId(appPackage,
						Integer.parseInt(schoolClassId));
				modelAndView.addObject("appPackageId", ap.getId());
			}

			if (sc != null)
				modelAndView.addObject("imgPath", sc.getImgPath());

		} catch (Exception e) {
			e.printStackTrace();
		}
		Offer o = offerService.findByStatus(true);
		System.out.println("appPackage :" + appPackage);
		System.out.println("schoolClassId :" + schoolClassId);
		System.out.println("Offer :" + o);
		modelAndView.addObject("appCountryCode", appCountryCode);
		modelAndView.addObject("response", response);
		modelAndView.addObject("appCountry", appCountry);
		modelAndView.addObject("schoolClass", schoolClass);
		modelAndView.addObject("schoolClassId", schoolClassId);
		modelAndView.addObject("appPackage", appPackage);
		modelAndView.addObject("countryPackages", countryPackages);
		modelAndView.addObject("countryCode", countryCode);
		modelAndView.addObject("offer", o);
		// modelAndView.addObject("activeClass", "packages_kids");
		if (registration != null && registration.getCountryCode() != null
				&& registration.getCountryCode().equals("91")) {
			// modelAndView.setViewName("packages_kids_in");
			// System.out.println("if k andr login");
			modelAndView.setViewName("packages_kids_in");
		} else if (registration != null && registration.getCountryCode() != null
				&& !registration.getCountryCode().equals("91")) {
			// System.out.println("else if k andr");
			modelAndView.setViewName("redirect:/us/purchase-pie");
		} else {
			// System.out.println("ye ku chal rha hai"+registration.getCountryCode());
			modelAndView.setViewName("packages_kids_in");
		}
		// modelAndView.setViewName("packages_kids_in");
		return modelAndView;
	}

	@RequestMapping(value = "payment_web")
	public ModelAndView paymentWebPOST(
			@ModelAttribute("subscriptionTransactionBean") SubscriptionTransactionBean subscriptionTransactionBean,
			ModelAndView modelAndView, HttpSession session) {
		System.out
				.println("inside payment web post.." + Integer.parseInt(subscriptionTransactionBean.getSchoolClass()));
		Integer registrationId = null;

		System.out.println("subscriptionTransactionBean subscriptionTransactionBean "
				+ new Gson().toJson(subscriptionTransactionBean));
		if (session != null && session.getAttribute("registrationId") != null) {

			registrationId = (Integer) session.getAttribute("registrationId");
			RegistrationAddress registrationAddress = registrationAddressService.findByRegistrationId(registrationId);
			Registration registration = registrationService.findById(registrationId);
			SchoolClass s = schoolClassService
					.getSchoolClassById(Integer.parseInt(subscriptionTransactionBean.getSchoolClass()));
			modelAndView.addObject("SchoolClassName", s.getName());
			if (CollectionUtils.isEmpty(subscriptionTransactionBean.getPackageTypeIds())) {
				modelAndView.addObject("error", "No Packages found.");
			} else if (subscriptionTransactionBean.getAmount() == null
					|| subscriptionTransactionBean.getAmount().equals(0)) {
				modelAndView.addObject("error", "Total Amount can not be 0.");
			} else {
				modelAndView.addObject("subscriptionTransactionBean", subscriptionTransactionBean);
				modelAndView.addObject("registrationAddress", registrationAddress);
			}
			if (registration != null)
				modelAndView.addObject("countryCode", subscriptionTransactionBean.getCountryCode());
			modelAndView.setViewName("payment_web_kids");
		} else {
			modelAndView.setViewName("redirect:/packages");
		}
		return modelAndView;
	}

	@RequestMapping(value = "payment_web2", method = { RequestMethod.POST, RequestMethod.GET })
	public ModelAndView paymentWebPOST2(
			@ModelAttribute("subscriptionTransactionBean") SubscriptionTransactionBean subscriptionTransactionBean,
			ModelAndView modelAndView, HttpSession session) {
		// System.err.println("iteration--"+subscriptionTransactionBean.getIteration());

		System.out.println("inside payment web post.." + new Gson().toJson(subscriptionTransactionBean));
		System.out.println("In Payment Web  School class Id : " + subscriptionTransactionBean.getSchoolClass());
		//
		
		Registration r = regserv.findById(Integer.parseInt("" + subscriptionTransactionBean.getRegistrationId()));
		
		RegistrationPackage registrationPackage = registrationPackageService
		.findByRegistration_IdAndPackageType_Id(r.getId(), 1);
		System.out.println("registrationPackage registrationPackage "+registrationPackage);
		if (registrationPackage == null) {
			Calendar cal = Calendar.getInstance();
			cal.add(Calendar.DATE, 7);

			Date date = dateUtility.convertDate(new Date());

			registrationPackage = new RegistrationPackage();
			registrationPackage.setCreatedAt(date);

			registrationPackage.setIsActive(StudentStatus.ACTIVE.getStatus());
			String registrationPackageCode = "STUDENT-" + commonUtility.generateStudentCode();
			registrationPackage.setTokenCode(registrationPackageCode);
			registrationPackage.setAccessToken(commonUtility.generateFreeStudentToken(registrationPackageCode, 7));
			registrationPackage.setExpiryDate(cal.getTime());
			registrationPackage.setPurchaseType(PurchaseType.FREE.getType());

			registrationPackage.setRegistration(r);

			AppPackage appPackage;
			if (r.getCountryCode().equals("91")) {
				appPackage = appPackageService.findByNameAndSchoolClassId("CBSE", 1);
			} else {
				appPackage = appPackageService.findByNameAndSchoolClassId("USA Curriculum", 5);
			}
			if (appPackage == null) {
				appPackage = appPackageService.findFirstByOrderById();
			}
			if (registrationPackageService.findByRegistration_IdAndPackageType_Id(r.getId(), 1) == null) {
				registrationPackage.setAppPackage(appPackage);
				registrationPackage.setPackageType(appPackage.getPackageType());
				registrationPackage = registrationPackageService.save(registrationPackage);

				registrationPackageCode = "STUDENT-" + registrationPackage.getId();
				registrationPackage.setTokenCode(registrationPackageCode);
				registrationPackage
						.setAccessToken(commonUtility.generateFreeStudentToken(registrationPackageCode, 7));
				registrationPackage = registrationPackageService.save(registrationPackage);
			}
		}

		AppPackage appPackage = appPackageService.findById(subscriptionTransactionBean.getAppPackageId());
		SchoolClass s = appPackage.getSchoolClass();
		modelAndView.addObject("SchoolClassName", s.getName());
//		subscriptionTransactionBean.set
		subscriptionTransactionBean.setSelectedCurriculum(s.getAppCountry().getName());
		subscriptionTransactionBean.setAppPackage(appPackage.getName());

		List<Integer> packageTypeIds = new ArrayList<Integer>(0);
		/*
		 * packageTypeIds. subscriptionTransactionBean.setPackageTypeIds(new A);
		 */
		if (appPackage != null) {
			subscriptionTransactionBean.setAppPackageId(appPackage.getId());
		}

		Integer registrationId = null;

		if (session != null && session.getAttribute("registrationId") != null) {

			registrationId = (Integer) session.getAttribute("registrationId");
			RegistrationAddress registrationAddress = registrationAddressService.findByRegistrationId(registrationId);
			Registration registration = registrationService.findById(registrationId);
			AndroidPackageTypePrice androidPackageTypePrice;

			if (subscriptionTransactionBean.getCountryCode() != null && !subscriptionTransactionBean.equals("")) {
				modelAndView.addObject("loginUserCountryCode", subscriptionTransactionBean.getCountryCode());
			}

			if (subscriptionTransactionBean.getAndroidPackageTypeIds() == null
					|| subscriptionTransactionBean.getAppPackageId() == null) {
				modelAndView.addObject("error", "No Packages found.");
			} /*
				 * else if (subscriptionTransactionBean.getAmount() == null ||
				 * subscriptionTransactionBean.getAmount().equals(0)) {
				 * modelAndView.addObject("error", "Total Amount can not be 0."); }
				 */ else {
				modelAndView.addObject("subscriptionTransactionBean", subscriptionTransactionBean);
				modelAndView.addObject("registrationAddress", registrationAddress);
			}
			if (registration != null) {
				androidPackageTypePrice = androidPackageTypePriceService
						.findById(subscriptionTransactionBean.getAndroidPackageTypeIds());
				if (subscriptionTransactionBean.getCountryCode() != null && !subscriptionTransactionBean.equals("")) {
					modelAndView.addObject("countryCode", androidPackageTypePrice.getCountryCode());

				} else {
					modelAndView.addObject("countryCode", registration.getCountryCode());
					// subscriptionTransactionBean.setCountryCode(registration.getCountryCode());
				}
				subscriptionTransactionBean.setCountryCode(androidPackageTypePrice.getCountryCode());
				subscriptionTransactionBean.setCurrencyType(androidPackageTypePrice.getCurrency());
				List<Integer> packgeList = new ArrayList<Integer>(0);
				packgeList.add(androidPackageTypePrice.getPackageTypeId());
				subscriptionTransactionBean.setPackageTypeIds(packgeList);

				if (subscriptionTransactionBean.getIteration() > 0) {
					subscriptionTransactionBean.setAmount(androidPackageTypePrice.getPrice()
							.multiply(BigDecimal.valueOf(subscriptionTransactionBean.getIteration())));
				} else {
					subscriptionTransactionBean.setAmount(androidPackageTypePrice.getPrice());
				}
				List<String> list = new ArrayList<>(0);
				list.add(androidPackageTypePrice.getSubHeading());
				subscriptionTransactionBean.setAvailablePackages(list);
			}

			modelAndView.setViewName("payment_web_kids");
			// modelAndView.setViewName("payment_web");
		} else {
			/*
			 * if (subscriptionTransactionBean.getCountryCode() != null &&
			 * !subscriptionTransactionBean.equals("")) {
			 * modelAndView.addObject("loginUserCountryCode",
			 * subscriptionTransactionBean.getCountryCode()); }
			 * 
			 * if (CollectionUtils.isEmpty(subscriptionTransactionBean.getPackageTypeIds()))
			 * { modelAndView.addObject("error", "No Packages found."); } else if
			 * (subscriptionTransactionBean.getAmount() == null ||
			 * subscriptionTransactionBean.getAmount().equals(0)) {
			 * modelAndView.addObject("error", "Total Amount can not be 0."); } else {
			 * modelAndView.addObject("subscriptionTransactionBean",
			 * subscriptionTransactionBean); } modelAndView.addObject("countryCode",
			 * subscriptionTransactionBean.getCountryCode());
			 */
			modelAndView.setViewName("redirect:/userLogin");

		}

		return modelAndView;
	}

	@RequestMapping(value = "/redirect_subscription_transaction", method = RequestMethod.POST)
	public String redirectSubscriptionTransaction(HttpServletRequest request, RedirectAttributes redirectAttributes) {
		HashMap hashMap = new HashMap<>();
		SubscriptionTransaction subscriptionTransaction = null;
		if (request != null && request.getParameter("encResp") != null) {
			hashMap = subscriptionTransactionService.processCcAvenueResponse(request.getParameter("encResp"),
					paymentWorkingKey);
			subscriptionTransaction = subscriptionTransactionService.processRedirectTransaction(hashMap);
		} else {
			subscriptionTransaction = new SubscriptionTransaction();
		}
		redirectAttributes.addFlashAttribute("subscriptionTransaction", subscriptionTransaction);
		return "redirect:/subscription_receipt";
	}

	@RequestMapping("logout")
	public ModelAndView test(ModelAndView mav, HttpServletRequest request, HttpServletResponse response) {
		try {
			System.out.println("Inside Logout");
			System.out.println("Inside Logout" + new Gson().toJson(request.getSession()));
			String sessionCountry = (String) request.getSession().getAttribute("country");
			System.out.println("sessionCountry :" + sessionCountry);
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			if (auth != null) {
				new SecurityContextLogoutHandler().logout(request, response, auth);
			}
			mav.setViewName("redirect:/" + sessionCountry);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return mav;
	}

	@RequestMapping(value = "/buy_subscription", method = RequestMethod.POST)
	public ModelAndView buySubscription(@Valid SubscriptionTransactionBean subscriptionTransactionBean,
			BindingResult bindingResult, GenericResponse response, ModelAndView modelAndView, HttpSession session,
			RedirectAttributes redirectAttributes) {
		System.out.println("inside buy subscription :");
		Integer registrationId = null;
		System.out.println("HI meet");
		try {
			response.setStatus(0);
			if (session != null && session.getAttribute("registrationId") != null) {
				registrationId = (Integer) session.getAttribute("registrationId");
				subscriptionTransactionBean.setRegistrationId(registrationId);
				session.setAttribute("appPackageId", subscriptionTransactionBean.getAppPackageId());

				modelAndView.setViewName("redirect:/payment_web");
				if (bindingResult.hasErrors()) {
					System.out.println("callig binding result :");
					redirectAttributes.addFlashAttribute("errors", bindingResult.getAllErrors());
				}
				subscriptionTransactionBean.setPaymentPaytmWebsite(paymentPaytmWebWebsite);
				System.out.println("calling paytm payment---------------");
				subscriptionService.processPaidSubscription(subscriptionTransactionBean, response);
				if (response != null && response.getError() == null
						&& "CCAVENUE".equals(subscriptionTransactionBean.getPaymentType())) {
					redirectAttributes.addFlashAttribute("response", response);
					modelAndView.setViewName("redirect:/payment1");
				} else if (response != null && response.getError() == null
						&& "PAYTM".equals(subscriptionTransactionBean.getPaymentType())) {
					redirectAttributes.addFlashAttribute("response", response);
					System.out
							.println("subscriptionTransactionBean :" + new Gson().toJson(subscriptionTransactionBean));
					modelAndView.setViewName("redirect:/payment2");
				} else if (response != null && response.getError() == null
						&& "STRIPE".equals(subscriptionTransactionBean.getPaymentType())) {
					System.out.println("stripe response :" + new Gson().toJson(response));
					redirectAttributes.addFlashAttribute("response", response);
					modelAndView.setViewName("redirect:/payment3");
				} else
					redirectAttributes.addFlashAttribute("errorMsg", response.getError());

				redirectAttributes.addFlashAttribute("subscriptionTransactionBean", subscriptionTransactionBean);
			} else {
				modelAndView.setViewName("redirect:/");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setError("Error in buying subscription.");
		}

		return modelAndView;
	}

	@RequestMapping(value = "/new_buy_subscription", method = RequestMethod.POST)
	public ModelAndView newBuySubscription(@Valid SubscriptionTransactionBean subscriptionTransactionBean,
			BindingResult bindingResult, GenericResponse response, ModelAndView modelAndView, HttpSession session,
			RedirectAttributes redirectAttributes) {
		Integer registrationId = null;
		/*
		 * s System.out.println("HI Jitendra ");
		 * System.out.println("applicantId "+subscriptionTransactionBean.getApplicantId(
		 * ));
		 * System.out.println("Amount  Amout "+subscriptionTransactionBean.getAmount());
		 * System.out.println("School Class Name  "+subscriptionTransactionBean.
		 * getSchoolName());
		 * System.out.println("getAndroidPackageTypeIds  "+subscriptionTransactionBean.
		 * getAndroidPackageTypeIds());
		 */

		subscriptionTransactionBean.setPlcId(subscriptionTransactionBean.getApplicantId());

		System.out.println("PLC ID " + subscriptionTransactionBean.getPlcId());

		System.out.println(
				"subscriptionTransactionBean.getAppPackageId() :" + subscriptionTransactionBean.getAppPackageId());

		System.out.println("subscriptionTransactionBean :" + new Gson().toJson(subscriptionTransactionBean));

		System.out.println("Inside buy_subscription");

		try {
			response.setStatus(0);
			if (session != null && session.getAttribute("registrationId") != null) {
				registrationId = (Integer) session.getAttribute("registrationId");
				subscriptionTransactionBean.setRegistrationId(registrationId);
				// subscriptionTransactionBean.setAmount(subscriptionTransactionBean.getAmount().multiply(BigDecimal.valueOf(subscriptionTransactionBean.getIteration())));

				session.setAttribute("appPkgId", subscriptionTransactionBean.getAppPackageId());

				modelAndView.setViewName("redirect:/payment_web2");
				if (bindingResult.hasErrors()) {
					redirectAttributes.addFlashAttribute("errors", bindingResult.getAllErrors());
				}
				subscriptionTransactionBean.setPaymentPaytmWebsite(paymentPaytmWebWebsite);

				System.out.println("calling paytm payment---------------");
				// subscriptionService.processPaidSubscription(subscriptionTransactionBean,
				// response);
				newsubscriptionService.processPaidSubscription(subscriptionTransactionBean, response);

				if (response != null && response.getError() == null
						&& "CCAVENUE".equals(subscriptionTransactionBean.getPaymentType())) {
					redirectAttributes.addFlashAttribute("response", response);
					modelAndView.setViewName("redirect:/payment1");
				} else if (response != null && response.getError() == null
						&& "PAYTM".equals(subscriptionTransactionBean.getPaymentType())) {
					
					redirectAttributes.addFlashAttribute("response", response);
					// System.out.println("subscriptionTransactionBean :" + new
					// Gson().toJson(subscriptionTransactionBean));
					modelAndView.setViewName("redirect:/payment2");
				} else if (response != null && response.getError() == null
						&& "STRIPE".equals(subscriptionTransactionBean.getPaymentType())) {
					// System.out.println("stripe response :" + new Gson().toJson(response));
					redirectAttributes.addFlashAttribute("response", response);
					modelAndView.setViewName("redirect:/payment3");
				} else {

					System.out.println("Error hai : " + response.getError());
					redirectAttributes.addFlashAttribute("errorMsg", response.getError());
				}

				redirectAttributes.addFlashAttribute("subscriptionTransactionBean", subscriptionTransactionBean);
			} else {
				modelAndView.setViewName("redirect:/");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.setError("Error in buying subscription.");
		}

		return modelAndView;
	}

	@RequestMapping(value = "payment2", method = RequestMethod.GET)
	public ModelAndView paymentPaytm(ModelAndView modelAndView, HttpServletRequest request) {

		try {
			System.out.println("payment2...");
			Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);

			if (inputFlashMap != null) {
				GenericResponse response = (GenericResponse) inputFlashMap.get("response");
				if (response != null && response.getData() != null && response.getError() == null) {
					SubscriptionTransactionDto sdt = (SubscriptionTransactionDto) response.getData();
					System.out.println("sdt " + sdt.toString());
					if (sdt != null && sdt.getAmount() != null && !sdt.getAmount().equals(0)) {
						if (sdt.getIsRecurring() != null && sdt.getIsRecurring() == 1) {
							System.out.println("inside is recurring one");
							modelAndView.addObject("isRecurring", sdt.getIsRecurring());
						} else {
							System.out.println("inside is recurring zero");
							modelAndView.addObject("isRecurring", 0);
						}
						System.out.println(sdt.getPaytmMerchantId() + " : " + sdt.getPaytmWebsite() + " : "
								+ sdt.getOrderId() + " : " + sdt.getPaytmCustId() + " : " + sdt.getPaytmMobile() + " : "
								+ sdt.getPaytmEmail() + " : " + sdt.getPaytmIndustryType() + " : "
								+ sdt.getPaytmChannelId() + " : " + sdt.getAmount() + " : " + sdt.getPaytmCallbackUrl()
								+ " : " + sdt.getPaytmChecksum());
						modelAndView.addObject("sdt", sdt);
					}
				} else {
					modelAndView.addObject("error", response.getError());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		modelAndView.setViewName("payment2");
		return modelAndView;
	}

	@RequestMapping(value = "/payment1", method = RequestMethod.GET)
	public ModelAndView paymentCCAvenue(ModelAndView modelAndView, HttpServletRequest request) {
		String ccaRequest = "";

		try {
			System.out.println("payment1...");
			Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
			if (inputFlashMap != null) {
				GenericResponse response = (GenericResponse) inputFlashMap.get("response");
				if (response != null && response.getData() != null && response.getError() == null) {
					SubscriptionTransactionDto subscriptionTransactionDto = (SubscriptionTransactionDto) response
							.getData();
					if (subscriptionTransactionDto != null && subscriptionTransactionDto.getAmount() != null
							&& !subscriptionTransactionDto.getAmount().equals(0)) {

						ccaRequest = ccaRequest + "merchant_id=" + subscriptionTransactionDto.getMerchantId()
								+ "&order_id=" + subscriptionTransactionDto.getOrderId() + "&currency="
								+ subscriptionTransactionDto.getCurrency() + "&amount="
								+ subscriptionTransactionDto.getAmount() + "&merchant_param2="
								+ subscriptionTransactionDto.getRegistration().getId() + "&redirect_url="
								+ paymentRedirectUrl + "&cancel_url=" + paymentCancelUrl + "";
						System.out.println("cca:" + ccaRequest);
						System.out.println(subscriptionTransactionDto.getAccessCode());
						AesCryptUtil aesUtil = new AesCryptUtil(paymentWorkingKey);
						ccaRequest = aesUtil.encrypt(ccaRequest);
						System.out.println("encrypted request parameter is: " + ccaRequest);
						modelAndView.addObject("accessCode", subscriptionTransactionDto.getAccessCode());
					}
				} else {
					modelAndView.addObject("error", response.getError());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.addObject("ccaRequest", ccaRequest);
		modelAndView.setViewName("payment1");
		return modelAndView;
	}

	@RequestMapping(value = "payment3", method = RequestMethod.GET)
	public ModelAndView paymentStripe(ModelAndView modelAndView, HttpServletRequest request) {

		try {
			System.out.println("payment3...");
			Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
			// System.out.println("inputFlashMap :" + new Gson().toJson(inputFlashMap));
			if (inputFlashMap != null) {
				GenericResponse response = (GenericResponse) inputFlashMap.get("response");
				if (response != null && response.getData() != null && response.getError() == null) {
					SubscriptionTransactionDto sdt = (SubscriptionTransactionDto) response.getData();
					if (sdt != null && sdt.getAmount() != null && !sdt.getAmount().equals(0)) {
						System.out.println(sdt.getStripeSessionId() + " : " + sdt.getOrderId());
						// System.out.println("sdt :" + new Gson().toJson(sdt));
						modelAndView.addObject("sdt", sdt);
					}
				} else {
					modelAndView.addObject("error", response.getError());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		modelAndView.setViewName("payment3");
		return modelAndView;
	}

	@RequestMapping(value = "subscription_receipt", method = RequestMethod.GET)
	public ModelAndView subscriptionReceipt(ModelAndView modelAndView, HttpServletRequest request,
			HttpSession session) {

		SubscriptionTransactionDto transaction = null;
		System.out.println("Inside subscription_receipt method...");
		try {
			Map<String, ?> inputFlashMap = RequestContextUtils.getInputFlashMap(request);
			if (inputFlashMap != null) {
				transaction = (SubscriptionTransactionDto) inputFlashMap.get("transaction");
			}

			modelAndView.addObject("transaction", transaction);
		} catch (Exception e) {
			e.printStackTrace();
		}
		modelAndView.setViewName("subscription_receipt");
		return modelAndView;
	}

	@RequestMapping(value = "/paytm_redirect_web_transaction")
	public ModelAndView paytmRedirectWebTransaction(HttpServletRequest request, RedirectAttributes redirectAttributes,
			ModelAndView modelAndView) {
		System.out.println("Redirect_Paytm_Web_Transaction");
		System.out.println("request : " + request);
		HashMap<String, String> hashMap = new HashMap<>();
		SubscriptionTransactionDto transaction = null;

		try {
			Enumeration<String> paramNames = request.getParameterNames();
			System.out.println("paramNames :" + new Gson().toJson(paramNames));
			Map<String, String[]> mapData = request.getParameterMap();
			TreeMap<String, String> parameters = new TreeMap<String, String>();
			String paytmChecksum = "";
			while (paramNames.hasMoreElements()) {
				String paramName = (String) paramNames.nextElement();
				System.out.println("Hi Meet paramName :" + paramName);
				if (paramName.equals("CHECKSUMHASH")) {
					System.out.println("first if sout");
					paytmChecksum = mapData.get(paramName)[0];
					System.out.println(paramName + " : checksum " + paytmChecksum);
				} else {
					System.out.println("first else sout");
					parameters.put(paramName, mapData.get(paramName)[0]);
					System.out.println(paramName + " : " + mapData.get(paramName)[0]);
				}
			}
			boolean isValideChecksum = CheckSumServiceHelper.getCheckSumServiceHelper()
					.verifycheckSum(paymentPaytmMerchantKey, parameters, paytmChecksum);
			System.out.println("isValideChecksum : " + isValideChecksum);
			hashMap.put("order_id", parameters.get("ORDERID"));
			SubscriptionTransaction st = subscriptionTransactionService.findByOrderId(parameters.get("ORDERID"));
			System.out.println("st : " + st.toString());
			hashMap.put("merchant_param2", String.valueOf(st.getRegistration().getId()));

			if (parameters.get("STATUS").equalsIgnoreCase("TXN_FAILURE")) {
				System.out.println("second if sout");
				transaction = new SubscriptionTransactionDto();
				transaction.setMessage("Error found in processing transaction details from Payment Gatewayyy.");
				transaction.setStatus("failure");
				redirectAttributes.addFlashAttribute("transaction", transaction);
				modelAndView.setViewName("redirect:/subscription_receipt");
				return modelAndView;

			} else if (isValideChecksum && parameters.containsKey("RESPCODE")) {
				System.out.println("second else if sout");
				if (parameters.get("RESPCODE").equals("01")) {
					System.out.println("payment success");
					hashMap.put("order_status", "Success");
					log.info("Payment processed successfully.");
				} else {
					System.out.println("payment failed");
					log.info("Payment failed.");
					hashMap.put("order_status", "failure");
				}
			} else {
				System.out.println("second else sout");
				transaction = new SubscriptionTransactionDto();
				log.info("checksum mismatch");
				hashMap.put("order_status", "failure");
				transaction.setMessage(parameters.get("RESPMSG"));
			}
			if (parameters.get("RESPCODE").equals("01")) {
				System.out.println("third if sout");
				transaction = subscriptionService.processRedirectTransaction(hashMap);
				log.info(parameters.get("RESPMSG"));
			}

		} catch (Exception e) {
			log.info("Error in processing.");
			e.printStackTrace();
		}

		if (transaction == null) {
			System.out.println("last if sout");
			transaction = new SubscriptionTransactionDto();
			transaction.setMessage("Error found in processing transaction details from Payment Gatewaaay.");
			transaction.setStatus("failure");
		}

		redirectAttributes.addFlashAttribute("transaction", transaction);
		modelAndView.setViewName("redirect:/subscription_receipt");
		return modelAndView;
	}

	@RequestMapping(value = "check-promo-code-coupon", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody ResponseEntity<GenericResponse> checkPromoCode(@RequestParam("coupon") String coupon,
			@RequestParam(value = "year_count", required = false) Integer year_count, GenericResponse response,
			@RequestParam("registrationId") Integer registrationId) {

		List<PromoCode> promoCodes = null;
		PromoCode promoCode = null;
		int couponUsedCount = 0;
		try {
			response.setStatus(0);
			coupon = coupon != null ? coupon.toUpperCase() : null;
			year_count = year_count != null && year_count != 0 ? year_count : 1;
			System.out.println("coupon code: " + coupon);
			promoCodes = promoCodeService.findByCoupon(coupon);
			if (promoCodes != null && !promoCodes.isEmpty()) {
				if (promoCodeService.checkValidCoupon(coupon, new Date())) {
					promoCode = promoCodeService.findByCouponBetweenStartDateAndEndDate(coupon, new Date()).get(0);
					couponUsedCount = registrationPackageService.findCouponUsedCountByRegistration(registrationId,
							promoCode.getId());
					System.out.println(promoCode.getTimesUsed());
					if (promoCode.getTimesUsed() != null && promoCode.getTimesUsed() != 0) {
						// promoCode.setTimesUsed(1);
						if (couponUsedCount < promoCode.getTimesUsed() && promoCode.getYearCount() == year_count) {
							response.setStatus(1);
							response.setData(promoCode);
						} else if (promoCode.getYearCount() != year_count) {
							response.setError("Wrong promo code applied");
						} else {
							response.setError("Maximum number of times this coupon used exceeds.");
						}
					} else {
						response.setStatus(1);
						response.setData(promoCode);
					}
				} else {
					response.setError("Promo code expired.");
				}
			} else {
				response.setError("Promo code not available.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setError("Error in checking promo code.");
		}

		return new ResponseEntity<GenericResponse>(response, HttpStatus.OK);
	}

	@RequestMapping(value = "find-all-phonics-videos", method = RequestMethod.GET)
	public ResponseEntity<GenericResponse> findAllPhonicsVideos(GenericResponse response) {
		System.out.println("Inside find all phonics videos.");
		List<PhonicsChildVideo> phonicsChildVideo = null;
		try {
			response.setStatus(0);
			phonicsChildVideo = phonicsChildVideoService.findAll();
			if (phonicsChildVideo != null && phonicsChildVideo.size() > 0) {
				response.setStatus(1);
				response.setData(phonicsChildVideo);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			response.setError("Error in fetching child phonics videos..");
		}
		return new ResponseEntity<GenericResponse>(response, HttpStatus.OK);
	}

	@RequestMapping(value = "find-all-phonics-games", method = RequestMethod.GET)
	public ResponseEntity<GenericResponse> findAllPhonicsGames(GenericResponse response) {
		System.out.println("Inside find all phonics games.");
		List<PhonicsChildGame> phonicsChildGames = null;
		try {
			response.setStatus(0);
			phonicsChildGames = phonicsChildGameService.findAll();
			if (phonicsChildGames != null && phonicsChildGames.size() > 0) {
				response.setStatus(1);
				response.setData(phonicsChildGames);
			}

		} catch (Exception ex) {
			ex.printStackTrace();
			response.setError("Error in fetching child phonics games..");
		}
		return new ResponseEntity<GenericResponse>(response, HttpStatus.OK);
	}

	@RequestMapping(path = "/ui/get/{fileName:.+}", method = RequestMethod.GET)
	public ResponseEntity<byte[]>/* ResponseEntity<Resource> */ downloadFile(@PathVariable String fileName,
			HttpServletRequest request, HttpSession session) throws Exception {
		byte[] response = null;
		if (session.getAttribute("registrationId") != null) {
			String url = "http://15.207.58.61:5080/LiveApp/streams/" + fileName;
			RestTemplate restTemplate = new RestTemplate();
			ResponseEntity<byte[]> response1 = restTemplate.getForEntity(url, byte[].class);
			return ResponseEntity.ok().body(response1.getBody());
		}
		return ResponseEntity.badRequest().body(null);
	}

//	@RequestMapping(value = "kids_login", method = RequestMethod.GET)
//	public String indexTest(ModelAndView modelAndView, HttpSession session) {
//		Integer regid = (Integer) session.getAttribute("registrationId");
//		try {
//			if (regid != null) {
//				Registration registration = registrationService.findById(regid);
//				if (registration != null) {
//					String userName = aes.encrypt(registration.getUsername());
//					System.out.println("registration id--" + userName);
//					modelAndView.addObject("userName", userName);
//					return "redirect:/kids_test/"+userName;
//				}
//
//			}
//		} catch (Exception e) {
//			// TODO: handle exception
//			e.printStackTrace();
//		}
//
//		return "redirect:/kids_test/";
//	}

	@RequestMapping(value = "/kids-game", method = RequestMethod.GET)
	public ModelAndView loginTest(ModelAndView modelAndView, HttpSession session) {
		System.out.println("Hellooo");
		Integer regid = (Integer) session.getAttribute("registrationId");

		Registration registration = registrationService.findById((Integer) session.getAttribute("registrationId"));
		System.out.println("registration " + registration);
		Integer packageTypeId = 1;
		RegistrationPackage registrationPackage = registrationPackageService
				.findByRegistration_IdAndPackageType_Id(registration.getId(), packageTypeId);

		try {

			if (regid != null && regid.toString() != "") {

				if (registration != null) {

					if (registrationPackage != null
							&& registrationPackage.getPurchaseType().equalsIgnoreCase(PurchaseType.PAID.toString())) {
						String userName = aes.encrypt(registration.getUsername());
						System.out.println("registration id--" + userName);
						modelAndView.addObject("info", webglPath + "?info=" + userName);
						modelAndView.setViewName("kids-app-webgl");
					} else {
						modelAndView.setViewName("redirect:/purchase-pie");
					}

				}

			} else {
				modelAndView.setViewName("redirect:/");
			}
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return modelAndView;
	}

	@RequestMapping(value = "/getLiveVideoYear", method = RequestMethod.GET, produces = "application/json")
	public ResponseEntity<GenericResponse> getLiveVideoYear(GenericResponse response) {

		try {
			List<String> classYear = new ArrayList<String>();
			int year = Year.now().getValue();
			// int year = 2025;

			int j = 22;
			for (int i = 2021; i <= year; i++) {
				classYear.add(i + "-" + j);
				j++;
			}
			Collections.reverse(classYear);
			response.setStatus(1);
			response.setData(classYear);

		} catch (Exception e) {
			e.printStackTrace();
			response.setError("Error in saving chapter..");
		}
		return new ResponseEntity<GenericResponse>(response, HttpStatus.OK);
	}
	
		
	
	@RequestMapping(value = "/check-new-promo-code-coupon", method = RequestMethod.GET, produces = "application/json")
	public @ResponseBody ResponseEntity<GenericResponse> checkNewPromoCode(@RequestParam("coupon") String coupon,
			@RequestParam(value = "year_count", required = false) Integer year_count,
			@RequestParam(value = "package_type", required = false) String packageType, GenericResponse response,
			@RequestParam("registrationId") Integer registrationId,
			@RequestParam(value = "appPackageTypeId") Integer appPackageTypeId) {

		PromoCode promoCodes = null;
		PromoCode promoCode = null;
		int couponUsedCount = 0;
		try {
			System.out.println("registrationId "+registrationId);
			response.setStatus(0);
			System.out.println("coupon :: coupon "+coupon);
			coupon = coupon != null ? coupon.toUpperCase() : null;
			System.out.println("year_count: " + year_count);
			year_count = year_count != null && year_count != 0 ? year_count : 1;

			System.out.println("coupon code: " + coupon + "app package ki id-" + appPackageTypeId);

			System.out.println("coupon code: " + coupon + "app package ki id-" + appPackageTypeId);

			promoCodes = promoCodeService.findByCouponAndAndroidPackageTypePriceId(coupon, appPackageTypeId);
			AndroidPackageTypePrice androidPackageTypePrice = androidPackageTypePriceService.findById(appPackageTypeId);
			/* System.out.println("androidPackageTypePrice : "+androidPackageTypePrice); */
			System.out.println("promoCodes " + promoCodes);
			if (promoCodes != null) {
				if (promoCodeService.checkValidCoupon(coupon, new Date())) {

					promoCode = promoCodeService.findByCouponBetweenStartDateAndEndDate(coupon, new Date()).get(0);
					promoCode.setCurrency(androidPackageTypePrice.getCurrency());

					System.out.println(promoCode.getTimesUsed());
					if (promoCode.getTimesUsed() != null && promoCode.getTimesUsed() != 0) {
						// promoCode.setTimesUsed(promoCode.getTimesUsed() - 1);
						/*
						 * if (packageType != null && packageType != "" &&
						 * !promoCode.getPackageType().getId().toString().equals(packageType)) {
						 * System.out.println(packageType);
						 * System.out.println(promoCode.getPackageType().getId().toString().equals(
						 * packageType)); response.setError("Wrong promo code applied"); return new
						 * ResponseEntity<GenericResponse>(response, HttpStatus.OK); }
						 */
						System.out.println("yEAR COUNT 2 : " + promoCode.getYearCount());
						if (couponUsedCount < promoCode.getTimesUsed() && promoCode.getYearCount() == year_count) {
							response.setStatus(1);
							response.setData(promoCode);
						} else if (promoCode.getYearCount() != year_count) {
							System.out.println("tthere");
							response.setError("Wrong promo code applied");
						} else {
							response.setError("Maximum number of times this coupon used exceeds.");
						}
					} else {
						response.setStatus(1);
						response.setData(promoCode);
					}
				} else {
					response.setError("Promo code expired.");
				}
			} else {
				response.setError("Promo code not available.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setError("Error in checking promo code.");
		}

		return new ResponseEntity<GenericResponse>(response, HttpStatus.OK);
	}

	
	
	

}
