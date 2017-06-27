<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/common/taglib.jsp" %>
<%@ include file="/WEB-INF/views/common/config.jsp" %>

<!DOCTYPE html>
<html lang="${accessibility}">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width">
	<title>Mago3D User</title>
	<%-- <link rel="stylesheet" href="/css/${lang}/font/font.css" /> --%>
<%-- 	<link rel="stylesheet" href="/images/${lang}/icon/glyph/glyphicon.css" />
	<link rel="stylesheet" href="/externlib/${lang}/normalize/normalize.min.css" /> --%>
<link rel="stylesheet" href="/css/${lang}/style.css" />
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto+Sans"> 
	<link rel="stylesheet" href="/css/${lang}/homepage-demo.css" />
	
		<link rel="stylesheet" href="/externlib/${lang}/jquery-ui/jquery-ui.css" />
	<link rel="stylesheet" href="/externlib/${lang}/jquery-toast/jquery.toast.css" />
	<script type="text/javascript" src="/externlib/${lang}/jquery/jquery.js"></script>
	<script type="text/javascript" src="/externlib/${lang}/jquery-ui/jquery-ui.js"></script>
	<script type="text/javascript" src="/externlib/${lang}/jquery-toast/jquery.toast.js"></script>
	<script type="text/javascript" src="/js/${lang}/common.js"></script>
	<script type="text/javascript" src="/js/${lang}/message.js"></script>
	<link rel="stylesheet" href="/externlib/${lang}/cesium/Widgets/widgets.css" />
</head>

<body>
	<div id="apiAndIssueArea">
		<ul>
			<li style="background-color : #573592"><a href="#issueContent" style="color: #FFFFFF">최근 등록한 이슈(30일 이내)</a></li>
		    <li style="background-color : #573592"><a href="#apiContent" style="color: #FFFFFF">API 목록</a></li>
		</ul>
		<div id="issueContent" style="background-color: #FFFFFF">
<c:if test="${empty issueList }">
			<div style="text-align: center; vertical-align:middle; height: 50px;">
				Issue가 존재하지 않습니다.
			</div>
</c:if>
<c:if test="${!empty issueList }">
	<c:forEach var="issue" items="${issueList}" varStatus="status">	
			<div>
				<div>
					<span>${status.count }</span>
					<span>${issue.title }</span>
				</div>
				<div id="issue_toggle_${issue.issue_id }">${issue.data_group_name } ${issue.viewInsertDate }</div>
			</div>
	</c:forEach>
</c:if>
		</div>
		<div id="apiContent" style="background-color: #FFFFFF">
			<div style="margin-top: 15px;">
				<span style="padding-right: 60px;">Data Key</span>
				<input type="text" id="data_key" name="data_key" size="15" />
				<button type="button" id="searchData" >검색</button>
			</div>
			<div style="margin-top: 15px;">
				<span style="padding-right: 40px;">Bounding Box</span>
				<input type="radio" id="showBoundingBox" name="boundingBox" value="true" onclick="changeBoundingBox(true);" />
				<label for="showBoundingBox"> 표시 </label>
				<input type="radio" id="hideBoundingBox" name="boundingBox" value="false" onclick="changeBoundingBox(false);"/>
				<label for="hideBoundingBox"> 비표시 </label>
			</div>
		</div>
	</div>

	<div class="trigger" >
		<button type="button"></button>
		<ul>
			<li><a href="/homepage/tutorials.do">Tutorials</a></li>
			<li><a href="/homepage/download.do">Download</a></li>
			<li><a href="/homepage/about.do">Mago3D</a></li>
			<li>Home</li>	
		</ul>
	</div>

	<div id="magoControllArea">
<c:forEach var="dataGroup" items="${projectDataGroupList}" varStatus="status">
		<div id="" style="padding-top:5px; width: 120px;">
			<img src="/images/${lang }/homepage/data_group_${status.count }.png" width="21px;" height="33px;" alt="Issue Input" />
	<c:if test="${dataGroup.data_group_name == 'JT' }">
			<a href="#" onclick="alert('preparing...');">
				<span style="padding-left:10px; width: 50px; bold; color: #FFFFFF;">${dataGroup.data_group_name }</span>
			</a>
	</c:if>
	<c:if test="${dataGroup.data_group_name != 'JT' }">
			<a href="#" onclick="flyTo('${dataGroup.longitude}', '${dataGroup.latitude}', '${dataGroup.height}', '${dataGroup.duration}')">
				<span style="padding-left:10px; width: 50px; bold; color: #FFFFFF;">${dataGroup.data_group_name }</span>
			</a>
	</c:if>
		</div>
</c:forEach>	
		<div style="height: 30px;"></div>
		<div id="issueEnable" style="width: 150px;">
			<img src="/images/${lang }/homepage/issue_input.png" alt="Issue Input" width="40px;" height="50px;" />
			<p />
			<span id="issueEnableLabel" style="margin-top: 5px; width: 50px; bold; color: #FFFFFF;">Issue 등록</span>
		</div>
		<div id="objectInfoEnable" style="margin-top:10px; width:150px;">
			<img src="/images/${lang }/homepage/info_view.png" alt="Info View" width="40px;" height="50px;" />
			<p />
			<span id="objectInfoEnableLabel" style="margin-top: 5px; width: 50px; bold; color: #FFFFFF;">Object 정보 표시</span>
		</div>
		<div id="issuesEnable" style="margin-top:10px; width:150px;">
			<img src="/images/${lang }/homepage/issue_list.png" alt="Info View" width="40px;" height="50px;" />
			<p />
			<span id="issuesEnableLabel" style="margin-top: 5px; width: 50px; bold; color: #FFFFFF;">Issue 목록</span>
		</div>
		
		<div style="margin-top:50px; width:150px;" onclick="inputIssue();">
			<span style="margin-top: 5px; width: 50px; bold; color: #FFFFFF;">API Call Test</span>
		</div>
	</div>
	
	<!-- 맵영역 -->
	<div id="magoContainer" style="position: absolute; width: 99%; height: 95%; margin-top: 0; padding: 0; overflow: hidden;"></div>

	<form:form id="issue" modelAttribute="issue" method="post" onsubmit="return false;">
	<div id="inputIssueLayer" style="display: none; top:40%; left:45%; width:450px; margin:-250px 0 0 -150px; " class="layer">
	    <div class="layerHeader">
	        <h2>Issue Register</h2>
	        <div>
	            <button id="inputIssueClose" type="button" title="닫기">닫기</button>
	        </div>
	    </div>
	    <div class="layerContents">
<!-- 	        <h4>테이블</h4> -->
	        <table>
	        	<tr>
	        		<th style="width: 120px;">
	        			<form:label path="data_group_id">데이터 그룹</form:label>
	        			<span class="icon-glyph glyph-emark-dot color-warning"></span>
	        		</th>
	        		<td>
	        			<form:select path="data_group_id" cssClass="select">
<c:forEach var="dataGroup" items="${projectDataGroupList}">
										<option value="${dataGroup.data_group_id}">${dataGroup.data_group_name}</option>
</c:forEach>
									</form:select>
	        		</td>
	        	</tr>
	        	<tr>
	        		<th>
	        			<form:label path="issue_type">Issue Type</form:label>
	        		</th>
	        		<td>
	        			<form:select path="issue_type" cssClass="select">
<c:forEach var="commonCode" items="${issueTypeList}">
										<option value="${commonCode.code_value}">${commonCode.code_value}</option>
</c:forEach>
						</form:select>
	        		</td>
	        	</tr>
	        	<tr>
	        		<th>
	        			<form:label path="data_key">Data Key</form:label>
	        			<span class="icon-glyph glyph-emark-dot color-warning"></span>
	        		</th>
	        		<td><form:input path="data_key" cssClass="ml" />
						<form:errors path="data_key" cssClass="error" />
						<form:hidden path="latitude"/>
						<form:hidden path="longitude"/>
	        		</td>
	        	</tr>
	        	<tr>
	        		<th>
	        			<form:label path="title">제목</form:label>
	        			<span class="icon-glyph glyph-emark-dot color-warning"></span>
	        		</th>
	        		<td><form:input path="title" cssClass="ml" />
						<form:errors path="title" cssClass="error" />
	        		</td>
	        	</tr>
	        	<tr>
	        		<th><form:label path="priority">Issue Type</form:label></th>
	        		<td>
	        			<form:select path="priority" cssClass="select">
<c:forEach var="commonCode" items="${issuePriorityList}">
							<option value="${commonCode.code_value}">${commonCode.code_value}</option>
</c:forEach>
						</form:select>
	        		</td>
	        	</tr>
	        	<tr>
	        		<th><form:label path="due_date">마감일</form:label></th>
	        		<td><form:hidden path="start_date" />
						<input type="text" id="start_day" name="start_day" placeholder="날짜" size="7" maxlength="4" />
						<input type="text" id="start_hour" name="start_hour" placeholder="시간" size="3" maxlength="2" />
						<span class="delimeter">:</span>
						<input type="text" id="start_minute" name="start_minute" placeholder="분" size="3" maxlength="2" />
	        		</td>
	        	</tr>
	        	<tr>
	        		<th><form:label path="assignee">Assignee</form:label></th>
	        		<td><form:input path="assignee" cssClass="m" placeholder="대리자" />
						<form:errors path="assignee" cssClass="error" />
	        		</td>
	        	</tr>
	        	<tr>
	        		<th><form:label path="reporter">reporter</form:label></th>
	        		<td><form:input path="reporter" cssClass="m" placeholder="보고 해야 하는 사람" />
						<form:errors path="reporter" cssClass="error" />
	        		</td>
	        	</tr>
	        	<tr>
	        		<th><form:label path="contents">내용</form:label></th>
	        		<td>
	        			<form:textarea path="contents" />
						<form:errors path="contents" cssClass="error" />
	        		</td>
	        	</tr>
	        </table>
	        
	      	<div class="btns">
	 			<button id="issueInsertButton">Save</button>
			</div>
	    </div>
	</div>
	</form:form>

<script type="text/javascript" src="/externlib/${lang}/cesium/Cesium.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Code.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/API.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Config.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Callback.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Constant.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Message.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/ManagerFactory.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Atmosphere.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/GeometryUtil.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/GeometryModifier.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Line.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Plane.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Point3D.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Shader.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/ShaderSource.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/ReaderWriter.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Renderer.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Selection.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/VBOManager.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/CesiumManager.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/PostFxShader.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/FBO.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Geometry.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Accessor.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/NeoTexture.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/BoundingBox.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/BlockModels.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/FileRequestControler.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/ManagerUtils.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/NeoReferenceModels.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/OcclusionCullOctree.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Octree.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/VisibleObjectsControler.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Matrix4.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Lego.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Camera.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/GeoLocationData.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/MagoFacade.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Policy.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Box.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Vertex.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Triangle.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/TriSurface.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/TriPolyhedron.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/VertexList.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/VertexMatrix.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Color.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Quaternion.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/domain/ProjectLayer.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/MetaData.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/SceneState.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/SplitValue.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Frustum.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/GeographicCoord.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/TerranTile.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/GlobeTile.js"></script>
<script type="text/javascript" src="/js/${lang}/mago3d/Sphere.js"></script>
<script>
	var policyJson = ${policyJson};
	var dataGroupMap = ${dataGroupMap};
	var insertIssueFlag = false;
	var objectInfoViewFlag = false;
	var listIssueFlag = false;
	var managerFactory = new ManagerFactory(null, "magoContainer", policyJson, dataGroupMap);
	
	function flyTo(longitude, latitude, height, duration) {
		managerFactory.flyTo(longitude, latitude, height, duration);
	}
	
	$( function() {
		$("#apiAndIssueArea" ).tabs();
	});


	
	// 이슈 등록
	$("#issueEnable").click(function() {
		if(insertIssueFlag) {
			insertIssueFlag = false;
			$("#issueEnableLabel").text("Issue 등록");
		} else {
			insertIssueFlag = true;
			$("#issueEnableLabel").text("활성화 상태");
		}
		changeInsertIssueModeAPI(insertIssueFlag);
	});
	// object info 표시
	$("#objectInfoEnable").click(function() {
		if(objectInfoViewFlag) {
			objectInfoViewFlag = false;
			$("#objectInfoEnableLabel").text("Object 정보 표시");
		} else {
			objectInfoViewFlag = true;
			$("#objectInfoEnableLabel").text("활성화 상태");
		}
		changeObjectInfoViewModeAPI(objectInfoViewFlag);
	});
	// issue list 표시
	$("#issuesEnable").click(function() {
		if(listIssueFlag) {
			listIssueFlag = false;
			$("#issuesEnableLabel").text("Issue 목록");
		} else {
			listIssueFlag = true;
			$("#issuesEnableLabel").text("활성화 상태");
		}
		changeListIssueViewModeAPI(listIssueFlag);
	});
	
	function inputIssue(data_name, data_key, latitude, longitude, elevation) {
		if(insertIssueFlag) {
			if($("#inputIssueLayer").css("display") == "none") {
				$("#inputIssueLayer").show();
				
				var dt = new Date();
				
				$("#data_name").val(dt.getFullYear() + "/" + (dt.getMonth()+1) + "/" + dt.getDate() + " " + dt.getHours() + "-" + dt.getMinutes() + "-" + dt.getSeconds());
				$("#data_key").val(dt.getFullYear() + "/" + (dt.getMonth()+1) + "/" + dt.getDate() + " " + dt.getHours() + "-" + dt.getMinutes() + "-" + dt.getSeconds());
				$("#latitude").val("37.57750");
				$("#longitude").val("126.89069");
				$("#elevation").val("60.0");
			}
		}
	}
	
	$("#inputIssueClose").click(function() {
		$("#inputIssueLayer").hide();
	});
	
	// object 정보 표시 call back function
	function showSelectedObject(projectId, blockId, objectId, latitude, longitude, elevation, heading, pitch, roll){
		if(objectInfoViewFlag) {
			$.toast({
			    heading: 'Click Object Info',
			    text: [
			        'projectId : ' + projectId, 
			        'blockId : ' + blockId, 
			        'objectId : ' + objectId,
			        'latitude : ' + latitude,
			        'longitude : ' + longitude,
			        'elevation : ' + elevation,
			        'heading : ' + heading,
			        'pitch : ' + pitch,
			        'roll : ' + roll
			    ],
				//bgColor : 'blue',
				hideAfter: 5000,
				icon: 'info'
			})
		}
	}
	
	function check() {
		if ($("#data_key").val() == "") {
			alert(JS_MESSAGE["issue.datakey.empty"]);
			$("#data_key").focus();
			return false;
		}
		if ($("#title").val() == "") {
			alert(JS_MESSAGE["issue.title.empty"]);
			$("#title").focus();
			return false;
		}
		/* if ($("#assignee").val() == "") {
			alert(JS_MESSAGE["issue.assignee.empty"]);
			$("#assignee").focus();
			return false;
		}
		if ($("#reporter").val() == "") {
			alert(JS_MESSAGE["issue.reporter.empty"]);
			$("#reporter").focus();
			return false;
		} */
		if ($("#contents").val() == "") {
			alert(JS_MESSAGE["issue.contents.empty"]);
			$("#contents").focus();
			return false;
		}
		if ($("#start_hour").val() > 23) {
			alert(JS_MEESAGE["issue.start_hour.proper"]);
			$("#start_hour").focus();
			return false;
		}
		if ($("#start_minute").val() > 59) {
			alert(JS_MESSAGE["issue.start_minute.proper"]);
			$("#start_minute").focus();
			return false;
		}
	}
	
	var isInsertIssue = true;
	$("#issueInsertButton").click(function() {
		if (check() == false) {
			return false;
		}
		if(isInsertIssue) {
			isInsertIssue = false;
			var info = $("#issue").serialize();		
			$.ajax({
				url: "/issue/ajax-insert-issue.do",
				type: "POST",
				data: info,
				cache: false,
				dataType: "json",
				success: function(msg){
					if(msg.result == "success") {
						alert(JS_MESSAGE["insert"]);
					} else {
						alert(JS_MESSAGE[msg.result]);
					}
					
					$("#inputIssueLayer").hide();
					isInsertIssue = true;
				},
				error:function(request,status,error){
			        //alert(JS_MESSAGE["ajax.error.message"]);
			        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			        isInsertIssue = true;
				}
			});
		} else {
			alert(JS_MESSAGE["button.dobule.click"]);
			return;
		}
	});
	
	
	// Data 검색
	$("#searchData").click(function() {
		searchDataAPI($("#data_key").val());
	});
	// boundingBox 표시/비표시
	function changeBoundingBox(isShow) {
		$("input:radio[name='boundingBox']:radio[value='" + isShow + "']").prop("checked", true);
		changeBoundingBoxAPI(isShow);
	}
</script>
</body>
</html>