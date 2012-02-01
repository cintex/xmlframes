unit U_ConstMessage;

{$IFDEF FPC}
{$MODE Delphi}
{$ENDIF}

interface

const
	// Code des fonctions
  	U_CST_SOUSFAMVENTE   = 'SV-37';
	  U_CST_SSFAMVENTE     = 'SV-38';
		U_CST_FAMVENTE       = 'SV-31';
		U_CST_COMPOSANT      = 'M-6' ;
		U_CST_CODEPOSTAL		 = 'M-9' ;
		U_CST_COMPOSEARTICLE = 'M-24' ;
		U_CST_DEVIS     		 = 'M-13';
		U_CST_CMDE     			 = 'M-26';
		U_CST_ARTICLE     	 = 'M-16';
		U_CST_FINITION    	 = 'M-3' ;
		U_CST_TYPEFINITION	 = 'M-27' ;
		U_CST_STRUCTURE			 = 'M-22' ;
		U_CST_CIVILITE			 = 'M-21' ;
		U_CST_CLIENT				 = 'M-1' ;
		U_CST_INTERLOCUTEUR	 = 'M-32' ;
		U_CST_GAMME					 = 'M-17' ;
		U_CST_CARACTERISTIQUE= 'M-19' ;
		U_CST_TYPEPRODUIT		 = 'M-18' ;
		U_CST_COMPORTEMENT	 = 'M-23' ;

		U_CST_DEVI__JALO_Reinformer = 100 ;
		U_CST_DEVI__JALO_Enregistre = 200 ;
		U_CST_DEVI__JALO_En_attente = 300 ;
		U_CST_DEVI__JALO_Valide		  = 400 ;
		U_CST_DEVI__JALO_Commande		= 500 ;
		U_CST_DEVI__JALO_Clos				= 600 ;
		U_CST_DEVI__JALO_Supprimer	= 999 ;

	// Code privilèges
  U_CST_AUTRE     = 100;
  U_CST_INVITE    = 200;
	U_CST_FRANCHISE = 300;
	U_CST_REPRESENTANT = 350;
  U_CST_ASSISTANT = 400;
  U_CST_CONTROLEGESTION = 450;
	U_CST_SIEGE     = 500;
	U_CST_ADMIN     = 600;
	// Format d'affichage
	U_CST_format_money_1 = ',0.00';
	U_CST_format_date_1 = 'dddd d mmmm yyyy';
	U_CST_format_date_2 = 'dd/mm/yyyy';
	U_CST_format_Money_Max_Chiffres_Avant_virgule = 14 ;
  U_CST_format_SmallMoney_Max_Chiffres_Avant_virgule = 5 ;
  U_CST_format_Taux_Max_Chiffres_Avant_virgule = 3 ;
	U_CST_format_TinyInt_Max_Chiffres = 2 ;
	U_CST_format_SmallInt_Max_Chiffres = 4 ;
	U_CST_format_Int_Max_Chiffres = 9 ;
	U_CST_format_BigInt_Max_Chiffres = 18 ;


	U_CST_Chemin_Edition = 'Editions\';

	// Messages d'alerte
	U_CST_9000 = 'Impossible de supprimer cet enregistrement. ' + #13
							 + 'Il est utilisé dans une autre fonction.';

	U_CST_9003 = 'Veuillez remplir la zone @ARG.';

	U_CST_9004 = 'Des @ARG sont encore membre de @ARG.'+ #13#10
							 + 'Désaffectez ces @ARG avant de supprimer @ARG.';

	U_CST_9005 = 'Des @ARG sont encore membre de @ARG.'+ #13#10
							 + 'Réaffectez ces @ARG avant de supprimer @ARG.';

	U_CST_9007 = 'La zone @ARG ne peut pas être vide.' + #13#13
							 + 'Effectuer une saisie ou annuler.';
	U_CST_9008 = '@ARG est déjà utilisé.';
	U_CST_9009 = 'Impossible de modifier cet enregistrement.' + #13
							 + 'Il est utilisé dans une autre fonction.';
	U_CST_9010 = 'Vous n''avez pas l''autorisation pour accéder à cette fonction.' + #13
							 + 'Contactez votre administrateur!';

	U_CST_9012 = 'La composition de l''article composé a changé.'+ #13#10 ;

	U_CST_9013 = 'La structure de l''article composé a changé.'+ #13#10 ;

	U_CST_9014 = 'Mot de passe invalide' + #13 + #13
						 + 'Veuillez resaisir votre mot de passe' ;
	U_CST_9015 = 'Nom d''utilisateur invalide' + #13 + #13
								 + 'Choisissez un nom d''utilisateur' ;

	U_CST_9016 = 'Veuillez vérifier votre sélection de @ARG.';

	U_CST_9017 = 'Le code @ARG est déjà utilisé.'+ #13
								+ 'Saisir un autre code ou annuler';
	U_CST_9018 = '@ARG est déjà utilisé.' + #13
							 + 'Saisir un autre numéro ou annuler.';

	U_CST_9020 = '@ARG doit être compris entre 0 et 100%.';

	U_CST_9021 = '@ARG doit être inférieur ou égal à 100%.';

	U_CST_9022 = '@ARG doit être un nombre supérieur ou égal à zéro.';

	U_CST_9023 = '@ARG ne peut être inférieur ou égal à zéro.';

	U_CST_9024 = '@ARG ne peut être égal à zéro.' ;

	U_CST_9026 = 'Des @ARG ne sont pas rattaché(e)s à @ARG.' + #13#10 + 'Vous ne pouvez quitter cette fonction.' ;

	U_CST_9027 = '@ARG non trouvé. La référence n''est pas accessible, a changé ou a été supprimée.' ;

	U_CST_9028 = '@ARG n''est pas valide.' + #13#10 + 'Un ou plusieurs @ARG sont à sélectionner.' ;

	U_CST_9029 = '@ARG est valide pour @ARG.' ;

	U_CST_9030 = 'Ce département est déjà assigné à un représentant.' ;
	U_CST_9031 = 'Vérifier si les composants sont valides' ;
	U_CST_9032 = 'Vous n''êtes pas habilité à effectuer cette modification.' ;
	U_CST_9033 = 'La copie est terminée.';

	U_CST_9034 = 'Vous devez choisir un jalonnement à envoyer.' ;

	// Messages d'erreur
	U_CST_9300 = 'Pas de connexion aux données de l''application.' ;
	U_CST_9301 = 'Seule la fonction d''Administration est accessible...';
	U_CST_9302 = 'Aucun devis n''est sélectionné, copie impossible.';
	U_CST_9303 = 'Aucun article n''est sélectionné, copie impossible.';
	U_CST_9304 = 'Enregistrement en cours, copie impossible.';
	U_CST_9305 = 'Impossible de faire la copie de @ARG.'+ #13 + '@ARG';
	U_CST_9306 = 'La composition de l''article n''est plus valide.'+ #13#10 ;

	U_CST_9307 = 'Veuillez sélectionner vos @ARG de nouveau.';


	// Messages de confirmation
	U_CST_9600 = 'La réinitialisation prendra effet au prochain démarrage de l''application.'
							 + #13 + 'Voulez-vous continuer ?';

	U_CST_9602 = 'Voulez-vous enregistrer vos modifications ?';

	U_CST_9605 = 'Voulez-vous quitter ?' ;
	U_CST_9606 = 'Voulez-vous tout fermer pour s''identifier ?' ;
	U_CST_9607 = 'Des @ARG sont encore membre de @ARG.'+ #13#10
							 + 'Voulez-vous Annuler pour désaffecter ces @ARG.';
	U_CST_9608 = 'Confirmez-vous la copie du devis ?';
	U_CST_9609 = 'Confirmez-vous la demande @ARG ?' ;

implementation

end.
