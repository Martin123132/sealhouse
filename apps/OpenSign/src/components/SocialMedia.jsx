import React from "react";
import { useTranslation } from "react-i18next";
import { NavLink } from "react-router";

const SocialMedia = () => {
  const { t } = useTranslation();
  const links = [
    {
      href: process.env.REACT_APP_GITHUB_URL,
      icon: "fa-brands fa-github",
      label: t("social-media.github")
    },
    {
      href: process.env.REACT_APP_LINKEDIN_URL,
      icon: "fa-brands fa-linkedin",
      label: t("social-media.linked-in")
    },
    {
      href: process.env.REACT_APP_X_URL,
      icon: "fa-brands fa-square-x-twitter",
      label: t("social-media.twitter")
    },
    {
      href: process.env.REACT_APP_DISCORD_URL,
      icon: "fa-brands fa-discord",
      label: t("social-media.discord")
    }
  ].filter((link) => link.href);

  if (links.length === 0) return null;

  return (
    <React.Fragment>
      {links.map((link) => (
        <NavLink
          key={link.href}
          to={link.href}
          target="_blank"
          rel="noopener noreferrer"
        >
          <i aria-hidden="true" className={link.icon}></i>
          <span className="fa-sr-only">{link.label}</span>
        </NavLink>
      ))}
    </React.Fragment>
  );
};

export default SocialMedia;
