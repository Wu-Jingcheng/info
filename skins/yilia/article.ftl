<#--

    Solo - A small and beautiful blogging system written in Java.
    Copyright (c) 2010-present, b3log.org

    Solo is licensed under Mulan PSL v2.
    You can use this software according to the terms and conditions of the Mulan PSL v2.
    You may obtain a copy of Mulan PSL v2 at:
            http://license.coscl.org.cn/MulanPSL2
    THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
    See the Mulan PSL v2 for more details.

-->
<#include "../../common-template/macro-common_head.ftl">
<#include "macro-comments.ftl">
<#include "../../common-template/macro-comment_script.ftl">
<!DOCTYPE html>
<html>
<head>
    <@head title="${article.articleTitle} - ${blogTitle}" description="${article.articleAbstract?html}">
        <link rel="stylesheet"
              href="${staticServePath}/skins/${skinDirName}/css/base.css?${staticResourceVersion}"/>
        <#if previousArticlePermalink??>
            <link rel="prev" title="${previousArticleTitle}" href="${servePath}${previousArticlePermalink}">
        </#if>
        <#if nextArticlePermalink??>
            <link rel="next" title="${nextArticleTitle}" href="${servePath}${nextArticlePermalink}">
        </#if>
    </@head>
</head>
<body>
<#include "side.ftl">
<main>
    <article class="post">
        <header class="fn__flex">
            <h2 class="fn__flex-1">
                <a rel="bookmark" href="${servePath}${article.articlePermalink}">
                    ${article.articleTitle}
                </a>
                <#if article.articlePutTop>
                    <sup>
                        ${topArticleLabel}
                    </sup>
                </#if>
            </h2>
            <time><span class="icon-date"></span> ${article.articleUpdateDate?string("yyyy-MM-dd")}</time>
        </header>
        <div class="article__footer fn__flex">
            <span class="icon-tag fn__flex-center"></span>
            <span>&nbsp;&nbsp;&nbsp;</span>
            <div class="tags fn__flex-1 fn__flex-center">
                <#list article.articleTags?split(",") as articleTag>
                    <a class="tag" rel="tag" href="${servePath}/tags/${articleTag?url('UTF-8')}">
                        ${articleTag}</a>
                </#list>
            </div>
            <span>&nbsp;&nbsp;&nbsp;</span>
            <#if commentable>
                <a href="${servePath}${article.articlePermalink}#b3logsolocomments"
                   class="vditor-tooltipped__n vditor-tooltipped link fn__flex-center"
                   aria-label="${commentLabel}">
                    <span data-uvstatcmt="${article.oId}">${article.articleCommentCount}</span>
                    <span class="icon-chat"></span>
                </a>
            </#if>
            <a class="vditor-tooltipped__n vditor-tooltipped link fn__flex-center"
               href="${servePath}${article.articlePermalink}"
               aria-label="${viewLabel}">
                <span data-uvstaturl="${servePath}${article.articlePermalink}">${article.articleViewCount}</span>
                <span class="icon-views"></span>
            </a>
            <a rel="nofollow" href="${servePath}/authors/${article.authorId}" class="fn__flex-center">
                <img class="avatar" title="${article.authorName}" alt="${article.authorName}"
                     src="${article.authorThumbnailURL}"/>
            </a>
        </div>

        <section class="abstract vditor-reset">
            ${article.articleContent}
            <#if "" != article.articleSign.signHTML?trim>
                <div>
                    ${article.articleSign.signHTML}
                </div>
            </#if>

            <#if nextArticlePermalink?? || previousArticlePermalink??>
                <aside class="fn__flex">
                    <#if previousArticlePermalink??>
                        <a class="fn__flex-1 fn__flex-inline" rel="prev" href="${servePath}${previousArticlePermalink}">
                            <strong>&lt;</strong>
                            <span>&nbsp; ${previousArticleTitle}&nbsp;&nbsp;&nbsp;</span>
                        </a>
                    </#if>
                    <#if nextArticlePermalink??>
                        <a class="fn__flex-inline" rel="next" href="${servePath}${nextArticlePermalink}">
                            <span>${nextArticleTitle}&nbsp; </span>
                            <strong>&gt;</strong>
                        </a>
                    </#if>
                </aside>
            </#if>
        </section>

        <footer class="fn-clear share">
            <div class="fn-right">
                <#include "../../common-template/share.ftl">
            </div>
        </footer>
        <#if 0 != relevantArticlesDisplayCount>
            <div id="relevantArticles" class="abstract"></div>
        </#if>
        <#if 0 != randomArticlesDisplayCount>
            <div id="randomArticles" class="abstract"></div>
        </#if>
        <#if externalRelevantArticlesDisplayCount?? && 0 != externalRelevantArticlesDisplayCount>
            <div id="externalRelevantArticles" class="abstract"></div>
        </#if>
        <br>
    </article>
    <#if commentable>
        <div id="b3logsolocomments"></div>
        <div id="vcomment" style="padding: 30px 60px 30px 50px;" data-name="${article.authorName}"
             data-postId="${article.oId}"></div>
        <#if !staticSite>
            <div id="soloComments" style="display: none;">
                <@comments commentList=articleComments article=article></@comments>
            </div>
        </#if>
    </#if>

    <#include "footer.ftl">

    <@comment_script oId=article.oId commentable=article.commentable>
        page.tips.externalRelevantArticlesDisplayCount = "${externalRelevantArticlesDisplayCount}";
        <#if 0 != externalRelevantArticlesDisplayCount>
            page.loadExternalRelevantArticles("<#list article.articleTags?split(",") as articleTag>${articleTag}<#if articleTag_has_next>,</#if></#list>");
        </#if>
        <#if 0 != randomArticlesDisplayCount>
            page.loadRandomArticles();
        </#if>
        <#if 0 != relevantArticlesDisplayCount>
            page.loadRelevantArticles('${article.oId}', '<h4>${relevantArticles1Label}</h4>');
        </#if>
        page.share()
    </@comment_script>
</main>
</body>
</html>
