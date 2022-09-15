{**
 * templates/frontend/objects/issue_toc_home.tpl
 *
 * Copyright (c) 2017-2021 Dominik Bláha
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Issue which displays a full table of contents for homepage.
 *
 * @uses $issue Issue The issue
 * @uses $issueTitle string Title of the issue. May be empty
 * @uses $issueSeries string Vol/No/Year string for the issue
 * @uses $issueGalleys array Galleys for the entire issue
 * @uses $hasAccess bool Can this user access galleys for this context?
 * @uses $publishedArticles array Lists of articles published in this issue
 *   sorted by section.
 *}

{if !$heading}
	{assign var="heading" value="h2"}
{/if}
{assign var="articleHeading" value="h3"}
{if $heading == "h3"}
	{assign var="articleHeading" value="h4"}
{elseif $heading == "h4"}
	{assign var="articleHeading" value="h5"}
{elseif $heading == "h5"}
	{assign var="articleHeading" value="h6"}
{/if}

<div class="obj_issue_toc">

	{* Issue introduction area *}
	<div class="heading">

		{* Issue cover image *}
		{assign var=issueCover value=$issue->getLocalizedCoverImageUrl()}
		{if $issueCover}
      <div class="homepage_image" style="background-image: url('{$issueCover|escape}');">
        <!--<a href="{url op="view" page="issue" path=$issue->getBestIssueId()}"></a>-->
        <div class="issue_overlay">
          {* Title *}
          <div class="current_issue_title">
            <a href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
              {$issue->getIssueIdentification()|strip_unsafe_html}
            </a>
          </div>

          {* Description *}
		{if $issue->hasDescription()}
			<div class="description">
				<a href="{url op="view" page="issue" path=$issue->getBestIssueId()}">
                    {$issue->getLocalizedDescription()|strip_unsafe_html}
                </a>
			</div>
		{/if}

          {* Published date *}
        {if $issue->getDatePublished()}
            <div class="published">
                <span class="label">
                    {translate key="submissions.published"}:
                </span>
                <span class="value">
                    {$issue->getDatePublished()|date_format:$dateFormatShort}
                </span>
            </div>
        {/if}

          {* Full-issue galleys *}
        {if $issueGalleys}
            <div class="galleys">
                {* <{$heading} id="issueTocGalleyLabel">
                    {translate key="issue.fullIssue"}
                </{$heading}> *}
                <ul class="galleys_links">
                    {foreach from=$issueGalleys item=galley}
                        <li>
                            {include file="frontend/objects/galley_link.tpl" parent=$issue labelledBy="issueTocGalleyLabel" purchaseFee=$currentJournal->getData('purchaseIssueFee') purchaseCurrency=$currentJournal->getData('currency')}
                        </li>
                    {/foreach}
                </ul>
            </div>
        {/if}

        </div>
      </div>
		{/if}

		{* PUb IDs (eg - DOI) *}
		{foreach from=$pubIdPlugins item=pubIdPlugin}
			{assign var=pubId value=$issue->getStoredPubId($pubIdPlugin->getPubIdType())}
			{if $pubId}
				{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
				<div class="pub_id {$pubIdPlugin->getPubIdType()|escape}">
					<span class="type">
						{$pubIdPlugin->getPubIdDisplayType()|escape}:
					</span>
					<span class="id">
						{if $doiUrl}
							<a href="{$doiUrl|escape}">
								{$doiUrl}
							</a>
						{else}
							{$pubId}
						{/if}
					</span>
				</div>
			{/if}
		{/foreach}
	</div>

	{* Articles *}
	<div class="sections">
	{foreach name=sections from=$publishedSubmissions item=section}
		<div class="section">
		{if $section.articles}
			{if $section.title}
				<{$heading}>
					{$section.title|escape}
				</{$heading}>
			{/if}
			<ul class="cmp_article_list articles">
				{foreach from=$section.articles item=article}
					<li>
						{include file="frontend/objects/article_summary.tpl" heading=$articleHeading}
					</li>
				{/foreach}
			</ul>
		{/if}
		</div>
	{/foreach}
	</div><!-- .sections -->
</div>