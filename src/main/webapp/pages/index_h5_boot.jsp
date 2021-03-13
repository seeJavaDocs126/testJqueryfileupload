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

    <script type="text/javascript">
        $(function () {
            InputFileUpload();
        });

        function InputFileUpload() {
            /*
             * 这是实现上传的核心代码 我们当前的要求如下 选择文件之后立即上传 上传过程中显示进度条 上传完成后显示提示文字“上传完成”
             * 再次添加要上传的文件后，应该将提示文字“上传成功”清除
             */
            $('#fileupload').fileupload({
                url: '/testupload/test/upload.do',
                Type : 'POST',    //请求方式
                dataType: 'json', //服务器返回的数据类型

                //autoUpload:是否自动上传，即当文件放入file之后便自动上传，默认为true
                autoUpload: true,
                //acceptFileTypes: /(\.|\/)(xlsx|png|jp?g|gif)$/i, // 允许上传的的文件类型
                //		maxNumberOfFiles: 1,//最大上传文件数目
                maxFileSize: 1024 * 1024 * 1024 * 2, // 最大上传文件大小
                minFileSize: 1, // 最小上传文件大小,单位B
                //使用方法一：函数属性
                // 全局上传处理事件的回调函数，即上传过程时触发
                // 设置进度条：用data.loaded与data.total的比进行完成
                /*progressall: function (e, data) {
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('progress').val(progress);
                    $('#upload_info').html(progress + '%');
                },
                //上传完成之后的操作，显示在img里面
                done: function (e, data) {
                    // 如果上传的图片，就取消下面代码的注释
                    //$("#uploadimg").attr('src', data.result.url);

                    $('#upload_info').html('上传完成');
                },*/
            })
                // 使用方法二：绑定事件监听函数，用.on()来用调用回调函数
                //显示上传进度条：用data.loaded与data.total的比进行完成
                .on('fileuploadprogressall', function(e, data) {
                    alert("显示上传进度条");
                    var progress = parseInt(data.loaded / data.total * 100, 10);
                    $('progress').val(progress);
                    $('#upload_info').html(progress + '%');
                })
                // 图片添加完成后触发的事件：用户再次选择文件后，清除提示文字，并设置进度条可见
                .on('fileuploadadd', function(e, data) {
                    alert("图片添加完成后触发的事件");
                    var mark = validate(data.files[0]); // 手动来验证文件大小
                    if (mark) {
                        $('.progress_box').css('display', 'block');
                        $('#upload_info').html('');
                    }
                    data.submit();
                })
                /*
                 * fileuploadadd 事件会在用户添加上传文件后触发
                 * 所以在这个事件中，我们将默认隐藏的进度条控件显示，并清除上次上传成功后的提示文本。 然后解释 done 事件
                 * 此事件会在服务器成功返回消息时触发，所以在这个事件中，我们显示图片预览以及显示成功后的提示文本
                 */
                // 上传请求成功时触发的回调函数
                .on('fileuploaddone', function (e, data) {
                    alert("上传请求成功时触发的回调函数");
                    $('#upload_info').html('上传完成');

                    var iconClass = "", attExt = "", html = "";
                    var res = data.result.data;
                    if (res.attExt != "") {
                        attExt = res.attExt.substring(1).toLowerCase();
                    }

                    if ($.inArray(attExt, imageFormatArray) != "-1") {
                        iconClass = "sfw-img";
                    } else if ($.inArray(attExt,
                        documentFormatArray) != "-1") {
                        iconClass = "sfw-txt";
                    } else if ($.inArray(attExt, videoFormatArray) != "-1") {
                        iconClass = "sfw-video";
                    } else {
                        iconClass = "sfw-txt";
                    }

                    html = html+
                        "<tr class='item' id='" + res.attachId + "'>" +
                        "<td class='type'><i class='icon sfw-icon "+ iconClass+ "'></i></td>" +
                        "<td class='title'><span class='td-content'>" + beautySub(res.attFilename) + "</span></td>" +
                        "<td class='datetime' style='border-collapse:collapse;border-left:60px solid white'>" +
                        "<span class='td-content'>" + new Date(res.uploadTime).format('yyyy-MM-dd ')+ "</span>" +
                        "</td>" +
                        "<td class='file-type' style='border-collapse:collapse;border-left:60px solid white'>" +
                        "<span class='td-content' name='attExt'>" + attExt + "</span>" +
                        "</td>" +
                        "<td class='file-size' style='border-collapse:collapse;border-left:60px solid white'>" +
                        "<span class='td-content'>" + bytesToSize(res.attSize) + "</span>" +
                        "</td>" +
                        "<td class='opt' style='border-collapse:collapse;border-left:60px solid white'>" +
                        "<a href='javascript:void(0);'><i class='icon sfw-icon sfw-del' onclick=delAttachment1(\"" + res.attachId+ "\")></i></a>" +
                        "</td>" +
                        "</tr>";
                    $("#attachment_list").append(html);

                    enclosureAttachmentIds.push(res.attachId);
                    attachmentCount++;
                    console.log("上传附件后enclosureAttachmentIds：" + enclosureAttachmentIds);

                    $("#attachmentCount").text("已上传附件" + attachmentCount + "个");
                    $("#AttachmentArea").removeClass("hidden");
                    $("#AttachmentArea").show();
                })
                //上传请求结束后，不管成功，错误或者中止都会被触发
                .on("fileuploadalways", function(e, data) {
                    alert("上传请求结束后，不管成功，错误或者中止都会被触发");
                    $('.progress_box').css('display', 'none');
                });
        }

        // 校验文件大小
        function validate(file) {
            //获取文件名称
            var fileName = file.name;

            //验证图片格式
            /*if (!/.(gif|jpg|jpeg|png|gif|jpg|png)$/.test(fileName)) {
                alert("上传文件格式不正确！");
                return false;
            }
            //验证excell表格式
            if(!/.(xls|xlsx)$/.test(fileName)){
                alert("上传文件格式不正确");
                return false;
            }*/

            // 获取文件大小
            var fileSize = file.size;
            if (fileSize > 1024 * 1024 * 1024 * 2) {
                alert("上传文件大小不能大于2G！");
                return false;

            } else if (fileSize == 0) {
                alert("上传文件大小不能为0！");
                return false;
            }

            return true;
        }
    </script>

</head>
<body>
    <div>
        <!-- 此处name="attach"与后台接收的MultipartFile 后的名称要统一 -->
        <input id="fileupload" type="file" name="attach">
        <div id="progress">
            <div class="bar" style="width: 0%;"></div>
        </div>
    </div>
</body>
</html>
