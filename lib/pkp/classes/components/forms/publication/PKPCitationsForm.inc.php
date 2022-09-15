<?php
/**
 * @file classes/components/form/publication/PKPCitationsForm.inc.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PKPCitationsForm
 * @ingroup classes_controllers_form
 *
 * @brief A preset form for setting a publication's citations
 */
namespace PKP\components\forms\publication;
use \PKP\components\forms\FormComponent;
use \PKP\components\forms\FieldTextarea;
use \PKP\components\forms\FieldHTML;
use \PKP\components\forms\FieldRichTextarea;

import('classes.handler.Handler');

define('FORM_CITATIONS', 'citations');

class PKPCitationsForm extends FormComponent {
	/** @copydoc FormComponent::$id */
	public $id = FORM_CITATIONS;

	/** @copydoc FormComponent::$method */
	public $method = 'PUT';

	/**
	 * Constructor
	 * 
	 * EDIT add references preview for editors and text field with formatting
	 *
	 * @param $action string URL to submit the form to
	 * @param $publication Publication The publication to change settings for
	 */
	public function __construct($action, $publication, $parsedCitations) {
		$this->action = $action;
		
		if($parsedCitations){
			$parsedCitationsArray = $parsedCitations->toArray();
			$parsedCitationsHTML = "";
			foreach($parsedCitationsArray as $parsedCitation){
				$parsedCitationLink = strip_tags($parsedCitation->getCitationWithLinks(),['em', 'i']);
				$parsedCitationsHTML .= "<p>" . $parsedCitation->getCitationWithLinks() . "</p>";
			}
		}
		
		$this->addField(new FieldRichTextarea('citationsRaw', [
			'label' => __('submission.citations'),
			'description' => __('submission.citations.description'),
			'value' => $publication->getData('citationsRaw'),
			'size' => 'large',
			//'toolbar' => 'italic',
		]));

		/* $this->addField(new FieldTextarea('citationsRaw', [
				'label' => __('submission.citations'),
				'description' => __('submission.citations.description'),
				'value' => $publication->getData('citationsRaw'),
			])); */

		if($parsedCitations){
			$this->addField(new FieldHTML('citationsTextPreviewHTML', [
				'label' => __('submission.citations.preview'),
				'description' => $parsedCitationsHTML,
			]));
		}
	}
}
