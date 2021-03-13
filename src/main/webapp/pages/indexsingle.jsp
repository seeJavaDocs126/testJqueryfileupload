<%--
  Created by IntelliJ IDEA.
  User: Administrator
  Date: 2021/2/26
  Time: 9:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String path = request.getContextPath();
%>
<html>
<head>
    <title>测试页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

    <!-- jquery file upload相关js -->
    <link rel="stylesheet" href="<%=path%>/libs/js/newupload/css/jquery.fileupload.css"/>
    <link rel="stylesheet" href="<%=path%>/libs/js/newupload/css/jquery.fileupload-ui.css"/>

    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/jquery.js"></script>
    <!-- jquery file upload相关js -->
    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/vendor/jquery.ui.widget.js"></script>
    <!--在IE下应载入此文件解决跨域问题 -->
    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/jquery.iframe-transport.js"></script>
    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/jquery.fileupload.js"></script>
    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/jquery.fileupload-process.js"></script>
    <!--如果需要文件类型验证必须引入 -->
    <script type="text/javascript" src="<%=path%>/libs/js/newupload/js/jquery.fileupload-validate.js"></script>


    <style type="text/css">
        /* input样式 */
        #uploadImg{
            display: none;
        }

        /* button样式 */
        #chooseFile{
            background: #93b6fc;
        }

        #uploadFile,#rechooseFile {
            display: none;
            background: #93b6fc;
        }

        #image{
            width:200px;
            height:200px;
        }

        /* 进度条样式 */
        .bar {
            background-image: -webkit-linear-gradient(top,#5cb85c 0,#449d44 100%);
            background-image: -o-linear-gradient(top,#5cb85c 0,#449d44 100%);
            background-image: -webkit-gradient(linear,left top,left bottom,from(#5cb85c),to(#449d44));
            background-image: linear-gradient(to bottom,#5cb85c 0,#449d44 100%);
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ff5cb85c', endColorstr='#ff449d44', GradientType=0);
            background-repeat: repeat-x;
            height: 20px;
            line-height: 20px;
            -webkit-box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
            box-shadow: inset 0 -1px 0 rgba(0,0,0,.15);
            -webkit-transition: width .6s ease;
            -o-transition: width .6s ease;
            transition: width .6s ease;
        }
        #progress {
            filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffebebeb', endColorstr='#fff5f5f5', GradientType=0);
            background-repeat: repeat-x;
            height: 10px;
            width: 0%;
            margin-bottom: 20px;
            overflow: hidden;
            background-color: #f5f5f5;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
            box-shadow: inset 0 1px 2px rgba(0,0,0,.1);
            margin-top: 20px;
        }
    </style>

    <script type="text/javascript">
        $(function() {

            $("#chooseFile").on("click", function() {
                $("#uploadImg").click();
            });

            $('#uploadImg').fileupload({
                url : '/testupload/test/upload.do',//请求发送的目标地址
                Type : 'POST',//请求方式 ，可以选择POST，PUT或者PATCH,默认POST
                //dataType : 'json',//服务器返回的数据类型
                autoUpload : false,
                acceptFileTypes : /(gif|jpe?g|png)$/i,//验证图片格式
                maxNumberOfFiles : 1,//最大上传文件数目
                maxFileSize : 1000000, // 文件上限1MB
                minFileSize : 100,//文件下限  100b
                messages : {//文件错误信息
                    acceptFileTypes : '文件类型不匹配',
                    maxFileSize : '文件过大',
                    minFileSize : '文件过小'
                }
            })
                //图片添加完成后触发的事件
                .on("fileuploadadd", function(e, data) {
                    //validate(data.files[0])这里也可以手动来验证文件格式和大小

                    //隐藏或显示页面元素
                    $('#progress .bar').css(
                        'width', '0%'
                    );
                    $('#progress').hide();
                    $("#chooseFile").hide();
                    $("#uploadFile").show();
                    $("#rechooseFile").show();

                    //获取图片路径并显示
                    var url = getUrl(data.files[0]);
                    $("#image").attr("src", url);

                    //绑定开始上传事件
                    $('#uploadFile').click(function() {
                        $("#uploadFile").hide();
                        jqXHR = data.submit();
                        //解绑，防止重复执行
                        $("#uploadFile").off("click");
                    })

                    //绑定点击重选事件
                    $("#rechooseFile").click(function(){
                        $("#uploadImg").click();
                        //解绑，防止重复执行
                        $("#rechooseFile").off("click");
                    })
                })
                //当一个单独的文件处理队列结束触发(验证文件格式和大小)
                .on("fileuploadprocessalways", function(e, data) {
                    //获取文件
                    file = data.files[0];
                    //获取错误信息
                    if (file.error) {
                        console.log(file.error);
                        $("#uploadFile").hide();
                    }
                })
                //显示上传进度条
                .on("fileuploadprogressall", function(e, data) {
                    $('#progress').show();
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('#progress').css(
                        'width','15%'
                    );
                    $('#progress .bar').css(
                        'width',progress + '%'
                    );
                })
                //上传请求失败时触发的回调函数
                .on("fileuploadfail", function(e, data) {
                    console.log(data.errorThrown);
                })
                //上传请求成功时触发的回调函数
                .on("fileuploaddone", function(e, data) {
                    alert(data.result);

                })
                //上传请求结束后，不管成功，错误或者中止都会被触发
                .on("fileuploadalways", function(e, data) {

                })


            //手动验证
            function validate(file) {
                //获取文件名称
                var fileName = file.name;
                //验证图片格式
                if (!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(fileName)) {
                    console.log("文件格式不正确");
                    return true;
                }
                //验证excell表格式
                /*  if(!/.(xls|xlsx)$/.test(fileName)){
                     alert("文件格式不正确");
                     return true;
                 } */

                //获取文件大小
                var fileSize = file.size;
                if (fileSize > 1024 * 1024) {
                    alert("文件不得大于一兆")
                    return true;
                }
                return false;
            }

            //获取图片地址
            function getUrl(file) {
                var url = null;
                if (window.createObjectURL != undefined) {
                    url = window.createObjectURL(file);
                } else if (window.URL != undefined) {
                    url = window.URL.createObjectURL(file);
                } else if (window.webkitURL != undefined) {
                    url = window.webkitURL.createObjectURL(file);
                }
                return url;
            }

        });

    </script>

</head>
<body>
<div class="jquery-fileupload">
    <div class="">
        <input id="uploadImg" type="file" name="attach" multiple style="display: none" />
        <button id="chooseFile">+选择文件</button>
        <button id="uploadFile">~开始上传</button>
        <button id="rechooseFile">+重新选择</button>
    </div>
    <div>
        <img id="image" src="">
    </div>
    <div id="progress"><div class="bar" style="width: 100%;"></div></div>
</div>
</body>
</html>
