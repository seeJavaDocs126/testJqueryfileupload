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
        .jquery-fileupload .uploadBtn {
            width: 80px;
            height: 36px;
            line-height: 28px;
            overflow: hidden;
            position: relative;
            float: left;
            margin-right: 10px;
        }
        .jquery-fileupload .uploadBtn input[type="file"] {
            width: 75px;
            height: 28px;
            position: absolute;
            left: 0;
            top: 0;
            z-index: 2;
            opacity: 0;
            filter: alpha(opacity=0);
        }
        .jquery-fileupload .uploadBtn span {
            display: block;
            width: 75px;
            height: 28px;
            position: absolute;
            left: 0;
            top: 0;
            line-height: 28px;
            text-align: center;
            color: black;
            font-weight: bold;
            font-size: 15px;
            text-decoration: none;
            border-radius: 8px;
            box-shadow: 0px 1px 3px #666666;
            /*text-shadow: 1px 1px 3px #666666;*/
            border: 2px solid #D1ECF0;
            background: #D1ECF0;
        }
        .jquery-fileupload table {
            width: 100%;
        }

        .jquery-fileupload .filesName tr {
            width: 100%;
        }

        .jquery-fileupload .filesName td {
            width: 50%;
            padding-left: 20px;
        }
        .jquery-fileupload .filesName .bar {
            height: 18px;
            background: green;
        }

        .jquery-fileupload .filesName .error {
            font-size: 16px;
            color: #a94442;
        }

        .progress_box {
            margin-bottom: 1px;
            color: #4cae4c;
        }

        .upload_delete {
            float: right;
            width: 35px;
            overflow: hidden;
            height: 20px;
            line-height: 25px;
            padding: 0 0 0 3px;
            font-size: 15px;
        }
        .upload_down {
            float: right;
            width: 35px;
            overflow: hidden;
            height: 20px;
            line-height: 25px;
            padding: 0 0 0 3px;
            font-size: 15px;
        }
        .upload_delete a:hover {
            color: red;
            text-decoration:underline;
        }
        .upload_down a:hover {
            color: red;
            text-decoration:underline;
        }


        .btn{
            display: inline-block;
            width: 75px;
            height: 25px;
            line-height: 25px;
            border: 1px solid #23c6c8;
            background: #23c6c8;
            color: #fff;
            text-align: center;
            font-size: 14px;
            border-radius: 3px;
            overflow: hidden;
            position: relative;
            vertical-align: center;
        }
        .btn:hover{
            border: 1px solid #23babc;
            background: #23BABC;
        }
        input{
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
        }

    </style>

    <script type="text/javascript">
        $(function () {
            //InputFileUpload();
            JOYIN.FILEUPLOAD.initOneConfig();
        });
        var JOYIN = {};
        JOYIN.FILEUPLOAD = {};
        JOYIN.FILEUPLOAD = {
            //渲染页面
            initOneConfig:function () {
                var labelnames = ["申请书列表","确认书列表"];
                // --------------------- 组装附件div的html 开始 ------------------
                var html = '<div class="jquery-fileupload"><fieldset id="_Container_0">';
                html += '<legend>'+'附件列表'+'</legend>';
                for (var index in labelnames) {
                    html +='<table> <tr> ';
                    html +='<td width="100px"> ';
                    html +=				labelnames[index] + ':';
                    html +='</td> ';
                    html +='<td> ';
                        html +='<div class="uploadBtn">';
                        html +='    <input id="uploadBtn'+index+'" type="file" name="attach" multiple />';
                        html +='    <span id="chooseFile">上传附件</span>';
                        html +='</div> ';
                    html +='</td> ';
                    html +='</tr> </table>';
                    html +='<table> ';
                    html +='<div id="uploadList'+index+'" ></div>';
                    html +='</table>';
                }
                html +=	'</fieldset></div>';
                $('#remark').closest('div').after(html);
                // --------------------- 组装附件控件的js 开始 ------------------
                for (var i in labelnames) {
                    JOYIN.FILEUPLOAD.init(i);
                }
                // --------------------- 组装附件控件的js 结束 ------------------
            },
            init:function (index) {
                /*
            * 这是实现上传的核心代码 我们当前的要求如下 选择文件之后立即上传 上传过程中显示进度条 上传完成后显示提示文字“上传完成”
            * 再次添加要上传的文件后，应该将提示文字“上传成功”清除
            */
                $('#uploadBtn'+index).fileupload({
                    url: '/testupload/test/upload.do',
                    Type : 'POST',    //请求方式
                    //dataType: 'json', //服务器返回的数据类型
                    //autoUpload:是否自动上传，即当文件放入file之后便自动上传，默认为true
                    autoUpload: false,
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
                    // 图片添加完成后触发的事件：用户再次选择文件后，清除提示文字，并设置进度条可见
                    .on('fileuploadadd', function(e, data) {
                        //alert(JSON.stringify(data));
                        var filename = data.files[0].name;
                        var fileListLenght = $("uploadList"+index).find('tr').length;
                        for (var i = 0; i < fileListLenght; i++) {
                            if (filename == $("uploadList"+index).find('.name').eq(i).text()) {
                                $('.tips').text("不能重复上传！");
                                return false;
                            }
                        }
                        // var filesList = "filesList" + fileListLenght;
                        // var filesListHTML = '<tr class="' + filesList + '">' +
                        //     '<td>' +
                        //         '<p class="name">' + filename + '</p>' +
                        //         '<div class="progress">' +
                        //         '<div class="bar" style="width: 0%;"></div>' +
                        //         '</div>' +
                        //     '</td>' +
                        //     '</tr>';
                        // $("uploadList"+index).append(filesListHTML);
                        // data.context = $("." + filesList);
                        data.submit();
                    })

                    // 使用方法二：绑定事件监听函数，用.on()来用调用回调函数
                    //显示上传进度条：用data.loaded与data.total的比进行完成
                    .on('fileuploadprogressall', function(e, data) {
                        var progress = parseInt(data.loaded / data.total * 100, 10);
                        // data.context.find('.bar').css('width', progress + '%');
                    })
                    /*
                     * fileuploadadd 事件会在用户添加上传文件后触发
                     * 所以在这个事件中，我们将默认隐藏的进度条控件显示，并清除上次上传成功后的提示文本。 然后解释 done 事件
                     * 此事件会在服务器成功返回消息时触发，所以在这个事件中，我们显示图片预览以及显示成功后的提示文本
                     */
                    // 上传请求成功时触发的回调函数
                    .on('fileuploaddone', function (e, data) {
                        //alert("done:"+JSON.stringify(data.context));
                       // $("uploadList"+index).find('.progress').parent().parent().remove();
                        var res = data.result.split(",");
                        if(res[0] == "success:"){
                            var filesList = "filesList" + $("#uploadList"+index).find('tr').length;
                            var filesListHTML ='<tr class="' + filesList + '">' +
                                '<td>' +
                                '<p class="name">' +res[3] +
                                '</p>' +
                                '</td>' +
                                '<td class="btns">' +
                                '<progress class="progress_box" value="100" max="100" style=" margin-left: 50px; height: 7px; width: 100px;"></progress>'+
                                '<span style="margin-left: 5px;">100%</span>'+
                                '<div class="upload_delete"><a class="delete">删除</a></div>' +
                                '<div class="upload_down"><a class="download">下载</a></div>' +
                                '</td>' +
                                '</tr>';
                            $("#uploadList"+index).append(filesListHTML);

                            $("."+filesList).find('.delete').click(function(){
                                alert("删除");
                                <%--window.location.hash='#top';--%>
                                <%--$.messager.confirm("信息提示","请注意，删除的附件将无法恢复，是否确认删除？",function(b){--%>
                                <%--    if(b){--%>
                                <%--        $.ajax({--%>
                                <%--            async:false,--%>
                                <%--            type:'post',--%>
                                <%--            url:'${app}/app/upload/fileUpload_delAttachment.shtml',--%>
                                <%--            dataType:'html',--%>
                                <%--            data:'id=' + res[2],--%>
                                <%--            success:function(msg){--%>
                                <%--                $("."+filesList).remove();--%>
                                <%--            }--%>
                                <%--        });--%>
                                <%--    }--%>
                                <%--    window.location.hash='#bottom';--%>
                                <%--});--%>
                            });

                            $("."+filesList).find('.download').click(function(){
                                alert("下载");
                                //downloadFile(res[1],res[3]);
                            });
                        }
                    })
                    //上传请求结束后，不管成功，错误或者中止都会被触发
                    .on("fileuploadalways", function(e, data) {
                        // alert("上传请求结束后，不管成功，错误或者中止都会被触发");
                        // $('.progress_box').css('display', 'none');
                    });
            }
        }

        function InputFileUpload() {
            /*
             * 这是实现上传的核心代码 我们当前的要求如下 选择文件之后立即上传 上传过程中显示进度条 上传完成后显示提示文字“上传完成”
             * 再次添加要上传的文件后，应该将提示文字“上传成功”清除
             */
            $('#fileupload').fileupload({
                url: '/testupload/test/upload.do',
                Type : 'POST',    //请求方式
                //dataType: 'json', //服务器返回的数据类型
                //autoUpload:是否自动上传，即当文件放入file之后便自动上传，默认为true
                autoUpload: false,
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
            // 图片添加完成后触发的事件：用户再次选择文件后，清除提示文字，并设置进度条可见
            .on('fileuploadadd', function(e, data) {
                var filename = data.files[0].name;
                var fileListLenght = $('.filesName').find('tr').length;
                for (var i = 0; i < fileListLenght; i++) {
                    if (filename == $('.filesName').find('.name').eq(i).text()) {
                        $('.tips').text("不能重复上传！");
                        return false;
                    }
                }
                var filesList = "filesList" + fileListLenght;
                var filesListHTML = '<tr class="' + filesList + '">' +
                    '<td>' +
                    '<p class="name">' + filename + '</p>' +
                    '<div class="progress">' +
                    '<div class="bar" style="width: 0%;"></div>' +
                    '</div>' +
                    '<strong class="error"></strong>' +
                    '</td>' +
                    '</tr>';
                $('.filesName').append(filesListHTML);
                data.context = $("." + filesList);
                data.submit();
            })

            // 使用方法二：绑定事件监听函数，用.on()来用调用回调函数
            //显示上传进度条：用data.loaded与data.total的比进行完成
            .on('fileuploadprogressall', function(e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
               // data.context.find('.bar').css('width', progress + '%');
            })
            /*
             * fileuploadadd 事件会在用户添加上传文件后触发
             * 所以在这个事件中，我们将默认隐藏的进度条控件显示，并清除上次上传成功后的提示文本。 然后解释 done 事件
             * 此事件会在服务器成功返回消息时触发，所以在这个事件中，我们显示图片预览以及显示成功后的提示文本
             */
            // 上传请求成功时触发的回调函数
            .on('fileuploaddone', function (e, data) {
                //alert("done:"+JSON.stringify(data.context));
                $('.filesName').find('.progress').parent().parent().remove();
                var res = data.result.split(",");
                if(res[0] == "success:"){
                    var filesList = "filesList" + $('.filesName').find('tr').length;
                    var filesListHTML ='<tr class="' + filesList + '">' +
                        '<td>' +
                        '<p class="name">' + res[3] + '</p>' +
                        '</td>' +
                        '<td class="btns">' +
                        '<button class="delete">删除</button>&nbsp;' +
                        '<button class="download">下载</button>' +
                        '</td>' +
                        '</tr>';
                    $(".filesName").append(filesListHTML);

                    $("."+filesList).find('.delete').click(function(){
                        window.location.hash='#top';
                        $.messager.confirm("信息提示","请注意，删除的附件将无法恢复，是否确认删除？",function(b){
                            if(b){
                                $.ajax({
                                    async:false,
                                    type:'post',
                                    url:'${app}/app/upload/fileUpload_delAttachment.shtml',
                                    dataType:'html',
                                    data:'id=' + res[2],
                                    success:function(msg){
                                        $("."+filesList).remove();
                                    }
                                });
                            }
                            window.location.hash='#bottom';
                        });
                    });

                    $("."+filesList).find('.download').click(function(){
                        downloadFile(res[1],res[3]);
                    });
                }
            })
            //上传请求结束后，不管成功，错误或者中止都会被触发
            .on("fileuploadalways", function(e, data) {
                // alert("上传请求结束后，不管成功，错误或者中止都会被触发");
                // $('.progress_box').css('display', 'none');
            });
        }

        /**
         * 附件下载
         * @param {Object} path 路径
         * @param {Object} fileName 文件名
         */
        function downloadFile(path,fileName){
            <%--if(getOs() == "Firefox"){--%>
            <%--	window.location.href="${app}/download.shtml?path=" + path +"&fileName="+fileName;--%>
            <%--}else{--%>
            <%--	window.location.href="${app}/download.shtml?path="+encodeURIComponent(encodeURIComponent(path))+"&fileName="+encodeURIComponent(encodeURIComponent(fileName));--%>
            <%--}--%>
            window.location.href="${app}/download.shtml?path="+encodeURIComponent(encodeURIComponent(path))+"&fileName="+encodeURIComponent(encodeURIComponent(fileName));
        }

    </script>

</head>
<body>
    <div id="remark"> </div>
<%--    <div class="jquery-fileupload">--%>
<%--        <div class="uploadBtn">--%>
<%--            <input id="fileupload" type="file" name="attach" multiple />--%>
<%--            <span id="chooseFile">上传附件</span>--%>
<%--        </div>--%>
<%--        <div class="progress_box">--%>
<%--            <!--上传进度使用 h5 中新增的 progress 元素，并创建一个id为upload_info 的控件，用于在上传完成后显示完成信息-->--%>
<%--            <progress value="0" max="100" style="position: absolute; left: 200px; height: 25px; width: 200px;"></progress>--%>
<%--            <span id="upload_info" style="position: absolute; left: 410px;"></span>--%>
<%--        <!--文件-->--%>
<%--        <table>--%>
<%--            <tbody class="filesName">--%>
<%--            </tbody>--%>
<%--        </table>--%>
<%--    </div>--%>

    <label class="btn">
        <span id="selects">选择图片</span>
        <input type="file" class="file" />
    </label>
</body>
</html>
