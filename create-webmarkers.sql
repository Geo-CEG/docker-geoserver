-- Table: clatsop.web_markers

DROP TABLE clatsop.web_markers;

CREATE TABLE clatsop_wm.web_markers
(
    id BIGSERIAL,
    geom geometry(Point,3857),
    label character varying(50) COLLATE pg_catalog."default",
    symbolid integer,
    notes character varying(100) COLLATE pg_catalog."default",
    CONSTRAINT web_markers_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE clatsop_wm.web_markers
    OWNER to gis_owner;
