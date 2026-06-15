/* ============================================================
   MODULE: dyspnoea
   SOURCE: Churchill's Pocketbook of Differential Diagnosis,
           3rd ed., Raftery, Lim, Ostor -- Elsevier 2010, p. 109-114
   AUTHORS: <your names>
   SYSTEM:  Respiratory / Cardiovascular

   DIAGNOSES TO ENCODE (from Churchill's):
   %   asthma                                 frequency: common
   %   copd                                   frequency: common
   %   heart_failure                          frequency: common
   %   pneumonia                              frequency: common
   %   pulmonary_embolism                     frequency: occasional
   %   pneumothorax                           frequency: occasional
   %   pleural_effusion                       frequency: occasional
   %   anaemia                                frequency: common
   %   pulmonary_fibrosis                     frequency: rare
   %   lung_cancer                            frequency: occasional

   SYMPTOM ATOMS (asserted by bridge as symptom/2):
   %   symptom(dyspnoea                      , Value)  -- type: yesno
   %   symptom(onset                         , Value)  -- type: choice: sudden|gradual|progressive
   %   symptom(worse_on_exertion             , Value)  -- type: yesno
   %   symptom(orthopnoea                    , Value)  -- type: yesno
   %   symptom(paroxysmal_nocturnal_dyspnoea , Value)  -- type: yesno
   %   symptom(wheeze                        , Value)  -- type: yesno
   %   symptom(cough                         , Value)  -- type: yesno
   %   symptom(haemoptysis                   , Value)  -- type: yesno
   %   symptom(chest_pain                    , Value)  -- type: yesno
   %   symptom(fever                         , Value)  -- type: yesno
   %   symptom(leg_swelling                  , Value)  -- type: yesno
   %   symptom(weight_loss                   , Value)  -- type: yesno
   %   symptom(smoking_history               , Value)  -- type: yesno

   FINDING ATOMS (asserted by bridge as finding/2):
   %   finding(wheeze_on_auscultation        , Value)  -- type: yesno
   %   finding(crepitations                  , Value)  -- type: yesno
   %   finding(reduced_air_entry             , Value)  -- type: yesno
   %   finding(peripheral_oedema             , Value)  -- type: yesno
   %   finding(jvp_elevated                  , Value)  -- type: yesno
   %   finding(tracheal_deviation            , Value)  -- type: yesno
   %   finding(dullness_to_percussion        , Value)  -- type: yesno

   INSTRUCTIONS:
   1. Fill in all five sections below.
   2. See prolog/modules/chest_pain.pl for a complete worked example.
   3. See docs/PROLOG_CONTRACT.md for the predicate specification.
   4. Run:  pytest tests/test_kb.py -v  -- all checks must pass.
   ============================================================ */

:- module(dyspnoea, [diagnose/2, frequency/2,
                   suggest_test/2, explain_step/3,
                   exclude_if/2]).

:- encoding(utf8).

% Stubs declared as discontiguous so the file loads cleanly before rules are added.
% Remove these lines once your module is complete.
:- discontiguous diagnose/2.
:- discontiguous frequency/2.
:- discontiguous suggest_test/2.
:- discontiguous explain_step/3.
:- discontiguous exclude_if/2.


/* ------------------------------------------------------------
   SECTION 1 -- FREQUENCY TABLE
   One fact per diagnosis. Values: common | occasional | rare
   Source: Churchill's colour coding for this presentation.
   ------------------------------------------------------------ */

frequency(asthma                                ,  common).
frequency(copd                                  ,  common).
frequency(heart_failure                         ,  common).
frequency(pneumonia                             ,  common).
frequency(pulmonary_embolism                    ,  occasional).
frequency(pneumothorax                          ,  occasional).
frequency(pleural_effusion                      ,  occasional).
frequency(anaemia                               ,  common).
frequency(pulmonary_fibrosis                    ,  rare).
frequency(lung_cancer                           ,  occasional).

/* ------------------------------------------------------------
   SECTION 2 -- DIAGNOSTIC RULES
   One diagnose/2 clause per distinct clinical picture.
   Each rule must end with:  frequency(Diagnosis, Frequency).
   ------------------------------------------------------------ */

% --- Respiratory ---

diagnose(asthma, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(wheeze, yes),
    finding(wheeze_on_auscultation, yes),
    frequency(asthma, Frequency).

diagnose(asthma, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(wheeze, yes),
    frequency(asthma, Frequency).


diagnose(copd, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    symptom(smoking_history, yes),
    finding(reduced_air_entry, yes),
    frequency(copd, Frequency).

diagnose(copd, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(smoking_history, yes),
    finding(reduced_air_entry, yes),
    frequency(copd, Frequency).


diagnose(pneumonia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(fever, yes),
    finding(crepitations, yes),
    frequency(pneumonia, Frequency).

diagnose(pneumonia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(fever, yes),
    symptom(chest_pain, yes),
    finding(crepitations, yes),
    frequency(pneumonia, Frequency).


diagnose(pneumothorax, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    finding(reduced_air_entry, yes),
    frequency(pneumothorax, Frequency).

diagnose(pneumothorax, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    finding(reduced_air_entry, yes),
    finding(tracheal_deviation, yes),
    frequency(pneumothorax, Frequency).


diagnose(pleural_effusion, Frequency) :-
    symptom(dyspnoea, yes),
    finding(reduced_air_entry, yes),
    finding(dullness_to_percussion, yes),
    frequency(pleural_effusion, Frequency).

diagnose(pleural_effusion, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(chest_pain, yes),
    finding(dullness_to_percussion, yes),
    frequency(pleural_effusion, Frequency).


diagnose(pulmonary_fibrosis, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    finding(crepitations, yes),
    \+ symptom(fever, yes),
    frequency(pulmonary_fibrosis, Frequency).

diagnose(pulmonary_fibrosis, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    symptom(cough, yes),
    finding(crepitations, yes),
    \+ symptom(smoking_history, yes),
    frequency(pulmonary_fibrosis, Frequency).


% --- Cardiovascular / vascular ---

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(orthopnoea, yes),
    finding(peripheral_oedema, yes),
    frequency(heart_failure, Frequency).

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(paroxysmal_nocturnal_dyspnoea, yes),
    finding(jvp_elevated, yes),
    frequency(heart_failure, Frequency).

diagnose(heart_failure, Frequency) :-
    symptom(dyspnoea, yes),
    finding(crepitations, yes),
    finding(peripheral_oedema, yes),
    frequency(heart_failure, Frequency).


diagnose(pulmonary_embolism, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    symptom(haemoptysis, yes),
    frequency(pulmonary_embolism, Frequency).

diagnose(pulmonary_embolism, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, sudden),
    symptom(chest_pain, yes),
    symptom(leg_swelling, yes),
    frequency(pulmonary_embolism, Frequency).


% --- Haematological / malignancy ---

diagnose(anaemia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(worse_on_exertion, yes),
    \+ symptom(wheeze, yes),
    \+ symptom(fever, yes),
    frequency(anaemia, Frequency).

diagnose(anaemia, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(onset, progressive),
    \+ finding(reduced_air_entry, yes),
    \+ finding(crepitations, yes),
    frequency(anaemia, Frequency).


diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(cough, yes),
    symptom(haemoptysis, yes),
    symptom(weight_loss, yes),
    frequency(lung_cancer, Frequency).

diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(smoking_history, yes),
    symptom(weight_loss, yes),
    frequency(lung_cancer, Frequency).

diagnose(lung_cancer, Frequency) :-
    symptom(dyspnoea, yes),
    symptom(haemoptysis, yes),
    symptom(smoking_history, yes),
    frequency(lung_cancer, Frequency).

    
% Pattern:
%   diagnose(<diagnosis_atom>, Frequency) :-
%       symptom(<atom>, yes),
%       ...,
%       frequency(<diagnosis_atom>, Frequency).

/* ------------------------------------------------------------
   SECTION 3 -- INVESTIGATIONS
   One suggest_test/2 fact per (diagnosis, test) pair.
   Source: Churchill's General and Specific Investigations sections.
   ------------------------------------------------------------ */

% Investigaciones para Asma (Basado en Churchill's)
suggest_test(asthma, peak_expiratory_flow_rate).
suggest_test(asthma, spirometry).
suggest_test(asthma, chest_xray).
suggest_test(asthma, pulse_oximetry).

% Investigaciones para Heart Failure
suggest_test(heart_failure, ecg).
suggest_test(heart_failure, chest_xray).
suggest_test(heart_failure, echocardiography).
suggest_test(heart_failure, bnp).
suggest_test(heart_failure, urea_electrolytes).

% Investigaciones para Pulmonary Embolism
suggest_test(pulmonary_embolism, d_dimer).
suggest_test(pulmonary_embolism, ct_pulmonary_angiography).
suggest_test(pulmonary_embolism, arterial_blood_gas).
suggest_test(pulmonary_embolism, ecg).
suggest_test(pulmonary_embolism, chest_xray).

% Investigaciones para Pneumothorax
suggest_test(pneumothorax, chest_xray).
suggest_test(pneumothorax, arterial_blood_gas).
suggest_test(pneumothorax, ct_chest).

% Investigaciones para Pleural Effusion
suggest_test(pleural_effusion, chest_xray).
suggest_test(pleural_effusion, thoracic_ultrasound).
suggest_test(pleural_effusion, pleural_fluid_analysis).
suggest_test(pleural_effusion, ct_chest).

% Investigaciones para Anaemia
suggest_test(anaemia, full_blood_count).
suggest_test(anaemia, haemoglobin).
suggest_test(anaemia, ferritin).
suggest_test(anaemia, blood_film).

% Investigaciones para Pulmonary Fibrosis
suggest_test(pulmonary_fibrosis, high_resolution_ct).
suggest_test(pulmonary_fibrosis, pulmonary_function_tests).
suggest_test(pulmonary_fibrosis, chest_xray).
suggest_test(pulmonary_fibrosis, oxygen_saturation).

% Investigaciones para Lung Cancer
suggest_test(lung_cancer, chest_xray).
suggest_test(lung_cancer, ct_chest).
suggest_test(lung_cancer, bronchoscopy).
suggest_test(lung_cancer, biopsy).
suggest_test(lung_cancer, sputum_cytology).


/* ------------------------------------------------------------
   SECTION 4 -- PROOF TRACE
   One explain_step/3 clause per symptom/finding each rule depends on.
   ------------------------------------------------------------ */

% Justificación clínica para Asma
explain_step(asthma, dyspnoea, 'Rationale: La disnea episódica es el síntoma cardinal de la obstrucción reversible del flujo aéreo característica del asma.').
explain_step(asthma, wheeze, 'Rationale: Las sibilancias indican un estrechamiento difuso de las vías respiratorias inferiores por broncoespasmo.').
explain_step(asthma, wheeze_on_auscultation, 'Rationale: La confirmación acústica de sibilancias espiratorias es el hallazgo físico primario durante una exacerbación asmática.').
explain_step(asthma, onset, 'Rationale: Un inicio súbito (sudden) de los síntomas respiratorios sugiere una respuesta broncoconstrictora aguda.').

% Investigaciones para EPOC
suggest_test(copd, spirometry).
suggest_test(copd, cxr).
suggest_test(copd, abg).
suggest_test(copd, fbc).
suggest_test(copd, ecg).

% Investigaciones para Neumonia
suggest_test(pneumonia, cxr).
suggest_test(pneumonia, fbc).
suggest_test(pneumonia, blood_cultures).
suggest_test(pneumonia, sputum_culture).
suggest_test(pneumonia, crp).

% Justificación clínica para EPOC
explain_step(copd, dyspnoea, 'Rationale: La limitación progresiva del flujo aéreo y la hiperinsuflación reducen la eficiencia ventilatoria.').
explain_step(copd, onset, 'Rationale: El daño alveolar y la remodelación ocurren a lo largo de décadas.').
explain_step(copd, smoking_history, 'Rationale: El humo del tabaco causa inflamación crónica y destrucción del parénquima pulmonar.').
explain_step(copd, reduced_air_entry, 'Rationale: La hiperinsuflación pulmonar y la obstrucción bronquial atenúan los ruidos respiratorios.').
explain_step(copd, cough, 'Rationale: La bronquitis crónica asociada produce hipersecreción de moco.').

% Justificación clínica para Neumonía
explain_step(pneumonia, dyspnoea, 'Rationale: La consolidación alveolar por exudado inflamatorio altera el intercambio gaseoso.').
explain_step(pneumonia, fever, 'Rationale: Respuesta inmunológica sistémica aguda a la infección en el parénquima pulmonar.').
explain_step(pneumonia, cough, 'Rationale: El exudado estimula el reflejo tusígeno, a menudo produciendo esputo purulento.').
explain_step(pneumonia, crepitations, 'Rationale: Apertura súbita de alvéolos ocupados por líquido inflamatorio.').
explain_step(pneumonia, chest_pain, 'Rationale: Indica que el proceso infeccioso se ha extendido a la superficie pleural.').

% ------------------------------------------------------------
% Heart Failure
% ------------------------------------------------------------

explain_step(heart_failure, orthopnoea,
 'Rationale: Orthopnoea occurs because lying flat increases venous return and worsens pulmonary congestion.').

explain_step(heart_failure, paroxysmal_nocturnal_dyspnoea,
 'Rationale: Nocturnal episodes of breathlessness are characteristic of left ventricular failure.').

explain_step(heart_failure, peripheral_oedema,
 'Rationale: Fluid retention due to impaired cardiac output causes peripheral oedema.').

explain_step(heart_failure, jvp_elevated,
 'Rationale: Elevated jugular venous pressure reflects systemic venous congestion.').

explain_step(heart_failure, crepitations,
 'Rationale: Pulmonary oedema produces inspiratory crackles on auscultation.').

% ------------------------------------------------------------
% Pulmonary Embolism
% ------------------------------------------------------------

explain_step(pulmonary_embolism, onset,
 'Rationale: Pulmonary embolism typically presents with sudden onset dyspnoea.').

explain_step(pulmonary_embolism, chest_pain,
 'Rationale: Pleuritic chest pain results from pulmonary infarction or pleural irritation.').

explain_step(pulmonary_embolism, haemoptysis,
 'Rationale: Haemoptysis may occur when pulmonary infarction develops.').

explain_step(pulmonary_embolism, leg_swelling,
 'Rationale: Leg swelling suggests deep vein thrombosis as the embolic source.').

% ------------------------------------------------------------
% Pneumothorax
% ------------------------------------------------------------

explain_step(pneumothorax, onset,
 'Rationale: Sudden dyspnoea is a classic presentation of pneumothorax.').

explain_step(pneumothorax, chest_pain,
 'Rationale: Pleural irritation produces sudden unilateral chest pain.').

explain_step(pneumothorax, reduced_air_entry,
 'Rationale: Collapsed lung tissue reduces ventilation and breath sounds.').

explain_step(pneumothorax, tracheal_deviation,
 'Rationale: Tracheal deviation suggests tension pneumothorax requiring urgent treatment.').

% ------------------------------------------------------------
% Pleural Effusion
% ------------------------------------------------------------

explain_step(pleural_effusion, dullness_to_percussion,
 'Rationale: Fluid in the pleural cavity produces percussion dullness.').

explain_step(pleural_effusion, reduced_air_entry,
 'Rationale: Pleural fluid dampens transmission of breath sounds.').

explain_step(pleural_effusion, chest_pain,
 'Rationale: Pleural inflammation may cause pleuritic chest pain.').

% ------------------------------------------------------------
% Anaemia
% ------------------------------------------------------------

explain_step(anaemia, dyspnoea,
 'Rationale: Tissue hypoxia increases respiratory drive and produces dyspnoea.').

explain_step(anaemia, worse_on_exertion,
 'Rationale: Reduced oxygen carrying capacity causes exertional breathlessness.').

explain_step(anaemia, onset,
 'Rationale: Anaemia commonly develops gradually over time.').

% ------------------------------------------------------------
% Pulmonary Fibrosis
% ------------------------------------------------------------

explain_step(pulmonary_fibrosis, onset,
 'Rationale: Pulmonary fibrosis usually presents with progressive dyspnoea.').

explain_step(pulmonary_fibrosis, crepitations,
 'Rationale: Fibrotic lung disease produces fine end-inspiratory crackles.').

explain_step(pulmonary_fibrosis, cough,
 'Rationale: Persistent dry cough is common in interstitial lung disease.').

% ------------------------------------------------------------
% Lung Cancer
% ------------------------------------------------------------

explain_step(lung_cancer, haemoptysis,
 'Rationale: Tumour invasion of airways commonly causes haemoptysis.').

explain_step(lung_cancer, weight_loss,
 'Rationale: Unexplained weight loss is a common constitutional feature of malignancy.').

explain_step(lung_cancer, smoking_history,
 'Rationale: Smoking is the principal risk factor for lung cancer.').

explain_step(lung_cancer, cough,
 'Rationale: Persistent cough may result from airway irritation or obstruction by tumour.').
/* ------------------------------------------------------------
   SECTION 5 -- EXCLUSION RULES  (optional but encouraged)
   ------------------------------------------------------------ */

% TODO: add exclude_if/2 rules here.
% exclude_if(<diagnosis>, 'Reason string') :-
%     finding(<finding_atom>, <value>). 
